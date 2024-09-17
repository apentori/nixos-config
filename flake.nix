{
  description = "My personal nix configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url  = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    # Thems 
    nix-colors.url = "github:misterio77/nix-colors";
    catppuccin.url = "github:catppuccin/nix";

  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    hardware,
    agenix,
    catppuccin,
    ...
  }@inputs:
    let
      overlay = final: prev: let
        unstablePkgs = import unstable { inherit (prev) system; config.allowUnfree = true; };
      in {
        unstable = unstablePkgs;
      };
    # Overlays-module makes "pkgs.unstable" available in configuration.nix
      overlayModule = ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay ]; });
      system = "x86_64-linux";

  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      pandora = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [./hosts/pandora/configuration.nix];
      };
      achilleus = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
        catppuccin.nixosModules.catppuccin
        ./hosts/achilleus/configuration.nix
        hardware.nixosModules.system76
        ];
      };
      hyperion = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
        overlayModule
        agenix.nixosModules.default
        ./hosts/hyperion/configuration.nix
        ];
      };
      mnemosyme = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs;};
        modules = [
        ./hosts/mnemosyme/configuration.nix
        ];
      };
   };
  };
}
