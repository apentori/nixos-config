{ pkgs, lib, config, ... }:
{
  imports = [
      ./ethereum/go-ethereum.nix
      ./ethereum/nimbus-eth2.nix
  ];
}
