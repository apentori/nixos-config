.PHONY: local remote

local:
	sudo nixos-rebuild switch --flake ".#achilleus"

remote-hyperion:
	nixos-rebuild switch --target-host irotnep@hyperion.irotnep.net --flake ".#hyperion" --use-remote-sudo
remote-mnemosyme:
	nixos-rebuild switch --target-host root@192.168.1.19 --flake ".#mnemosyme"

