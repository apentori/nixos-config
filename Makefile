.PHONY: local remote test
test:
	HOST=$(shell hostname)
	echo ${HOST}

local:
	HOST=$(shell hostname)
	NIX_SSHOPTS="-t"
	sudo nixos-rebuild switch --flake ".#$(shell hostname)"

remote-hyperion:
	nixos-rebuild switch --target-host irotnep@hyperion.irotnep.net --flake ".#hyperion" --use-remote-sudo
remote-mnemosyme:
	nixos-rebuild switch --target-host root@192.168.1.19 --flake ".#mnemosyme"

