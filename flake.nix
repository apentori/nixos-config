{
  description = "My personal nix configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url  = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    ...
  }@inputs:
    let
      system = "x86_64-linux";
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      pandora = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        # > Our main nixos configuration file <
        modules = [./hosts/pandora/configuration.nix];
      };
      achilleus = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        # > Our main nixos configuration file <
        modules = [
        ./hosts/achilleus/configuration.nix
        inputs.hardware.nixosModules.system76
        ];
      };
   };
  };
}
