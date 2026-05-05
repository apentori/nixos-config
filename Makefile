.PHONY: local remote test
test:
	HOST=$(shell hostname)
	echo ${HOST}

local:
	HOST=$(shell hostname)
	NIX_SSHOPTS="-t"
	sudo nixos-rebuild switch --flake ".#$(shell hostname)"

remote-hyperion:
	nixos-rebuild switch --target-host irotnep@hyperion.irotnep.net --flake ".#hyperion" --use-remote-sudo --ask-sudo-password
remote-mnemosyme:
	nixos-rebuild switch --target-host root@192.168.1.19 --flake ".#mnemosyme"
remote-atlas:
	nixos-rebuild switch --target-host irotnep@192.168.1.17 --flake ".#atlas" --use-remote-sudo --ask-sudo-password
