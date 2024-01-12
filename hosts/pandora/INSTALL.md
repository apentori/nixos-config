# Installation procedure

Open a console on installer
* Create partition:
  * `parted /dev/sda -- mklabel gpt`
  * `parted /dev/sda  -- mkpart 'EFI'  2MiB 1GiB set 1 esp on`
  * `parted /dev/sda -- mkpart 'ZFS'   '100%'`
* Create ZFS pool with encryption and mount point
```shell
$ zpool create -O encryption=on -O keyformat=passphrase -O keylocation=prompt -O compression=on -O mountpoint=none -O xattr=sa -O acltype=posixacl zpool /dev/sda2
$ zfs create -o mountpoint=legacy zpool/root
$ zfs create -o mountpoint=legacy zpool/nix
$ zfs create -o mountpoint=legacy zpool/var
$ zfs create -o mountpoint=legacy zpool/home

$ mkdir /mnt/root
$ mount -t zfs zpool/root /mnt
$ mkdir /mnt/nix /mnt/var /mnt/home

$ mount -t zfs zpool/nix /mnt/nix
$ mount -t zfs zpool/var /mnt/var
$ mount -t zfs zpool/home /mnt/home
```
* Mount boot partition 
```bash
mkfs.fat -F 32 -n boot /dev/sda1
mount /dev/disk/by-label/boot /mnt/boot
```

* Generate default config: `nixos-generate-configuration --root /mnt`
* Clone this repository in the installer partition and install with:
```bash
nixos-install --flake .#pandora
```

> FIXME: See why the installation with github link doesn't work `nixos-install --flake https://github.com/apentori/nixos-config#pandora`
