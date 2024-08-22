# Nix Configuration

## Description

This repo contains the NixOs configuration for my home setup.

## Usage

* Run `sudo nixos-rebuild switch --flake .#hostname` to apply the system configuration.
* Run `sudo nixos-install --flake .#hostname` if still in a live installation medium.

To deploy on a remote host:

```
# To have the remote sudo password prompt
NIX_SSHOPTS="-o RequestTTY=force"
nixos-rebuild switch \
    --target-host irotnep@<host-domain> 
    --flake .#hostname --use-remote-sudo
```
