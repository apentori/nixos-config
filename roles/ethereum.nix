{ pkgs, lib, config, ... }:
{
  imports = [
      ./roles/go-ethereum.nix
      ./nimbus-eth2.nix
  ];
}
