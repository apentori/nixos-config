{
  description = "My personal nix configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url  = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    agenix.url   = "github:ryantm/agenix";
    # Tools
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos";
    trade-tracker.url = "github:apentori/evm-trade-tracker?rev=8389a97e3f8ce899c9032efa7f0c04d962d78568";
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    hardware,
    agenix,
    zen-browser,
    tuxedo-nixos,
    trade-tracker,
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
        specialArgs = {inherit inputs; system = "x86_64-linux";};
        modules = [
        agenix.nixosModules.default
        ./hosts/achilleus/configuration.nix
        hardware.nixosModules.system76
        ];
      };
      hermes = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs; system = "x86_64-linux";};
        modules = [
        agenix.nixosModules.default
        hardware.nixosModules.common-cpu-amd
        hardware.nixosModules.common-gpu-amd
        tuxedo-nixos.nixosModules.default
        ./hosts/hermes/configuration.nix
        ];
      };
      theseus = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
        ./hosts/theseus/configuration.nix
        ];
      };
      hyperion = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
        overlayModule
        agenix.nixosModules.default
        trade-tracker.nixosModules.default
        ./hosts/hyperion/configuration.nix
        ];
      };
      mnemosyme = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs;};
        modules = [
        agenix.nixosModules.default
        ./hosts/mnemosyme/configuration.nix
        ];
      };
      atlas = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
        overlayModule
        agenix.nixosModules.default
        ./hosts/atlas/configuration.nix
        ];

      };
   };
  };
}
