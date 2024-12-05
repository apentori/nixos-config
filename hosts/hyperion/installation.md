# Installation

Describe the step to install `hyperion` host.

## First Step

Boot the server on rescue mod, ssh into it.
Install a nixos version with kexec:
```bash
curl --location https://github.com/nix-community/nixos-images/releases/download/nixos-22.11/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz | tar -C /root -xvzf-
/root/kexec/run
```

## Partitioning

Define the disks:

```bash
export DISK1=/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V6H00B9S
export DISK2=/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V1JUHSKH
export DISK3=/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V1HML8LH
export DISK4=/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V6GMXTYS
```

Create boot, swap and ZFS volumes partitions:

```bash
format() {
  parted -s --align optimal "$1" -- mklabel gpt
  parted -s --align optimal "$1" -- mkpart 'EFI'  1MiB 1GiB set 2 esp on
  parted -s --align optimal "$1" -- mkpart 'SWAP' 1GiB 17GiB set 2 esp on
  parted -s --align optimal "$1" -- mkpart 'ZFS'  17GiB '100%'
  parted -s --align optimal "$1" -- print
}

format $DISK1
format $DISK2
format $DISK3
format $DISK4
```

Result:

```bash
$ parted -l
Model: ATA HGST HUS726T4TAL (scsi)
Disk /dev/sdc: 4001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system     Name  Flags
 1      1049kB  1074MB  1073MB  fat32           EFI
 2      1074MB  18.3GB  17.2GB  linux-swap(v1)  SWAP  boot, esp
 3      18.3GB  4001GB  3983GB                  ZFS


Model: ATA HGST HUS726T4TAL (scsi)
Disk /dev/sdd: 4001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system     Name  Flags
 1      1049kB  1074MB  1073MB  fat32           EFI
 2      1074MB  18.3GB  17.2GB  linux-swap(v1)  SWAP  boot, esp
 3      18.3GB  4001GB  3983GB                  ZFS
```

## Preparte the partions

Prepare boot partitions:

```bash
mkfs.fat -F 32 -n boot $DISK1-part1
mkfs.fat -F 32 -n boot $DISK2-part1
mkfs.fat -F 32 -n boot $DISK3-part1
mkfs.fat -F 32 -n boot $DISK4-part1

```

Prepare Swap partitions:

```bash
mkswap $DISK1-part2
mkswap $DISK2-part2
mkswap $DISK3-part2
mkswap $DISK4-part2
swapon $DISK1-part2
swapon $DISK2-part2
swapon $DISK3-part2
swapon $DISK4-part2
```

## ZFS

Create ZFS Pool:

```bash
zpool create -f -O mountpoint=legacy \
    -O acltype=posixacl \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O atime=off \
    -O xattr=sa \
    zpool mirror $DISK1-part3 $DISK2-part3 $DISK3-part3 $DISK4-part3
```

Create the differentes volumes:

```
zfs create -o quota=50G -o reservation=50G zpool/root
zfs create -o quota=50G -o reservation=50G zpool/nix
zfs create -o quota=20G -o reservation=20G zpool/home
zfs create -o quota=1.5T -o reservation=1.5T zpool/data
```

## NixOS installation

Mount the differents partitions and ZFS Volumes

```
mount -t zfs zpool/root /mnt
mkdir /mnt/home/ /mnt/nix /mnt/boot1 /mnt/boot2 /mnt/boot3 /mnt/boot4 /mnt/data
mount -t zfs zpool/home /mnt/home
mount -t zfs zpool/nix /mnt/nix
mount -t zfs zpool/data /mnt/data
mount $DISK1-part1 /mnt/boot1
mount $DISK2-part1 /mnt/boot2
mount $DISK3-part1 /mnt/boot3
mount $DISK4-part1 /mnt/boot4
```

Generate the NixOS configuration

```bash
nixos-generate-config --root /mnt
```

Update the channel:

```
nix-channel --list
nix-channel --add https://nixos.org/channels/nixos-24.05 nixos
nix-channel --update
```

```nix
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    forceInstall = true;
    #efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V6H00B9S"]; path = "/boot1"; }
      { devices = [ "/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V1JUHSKH"]; path = "/boot2"; }
      { devices = [ "/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V1HML8LH"]; path = "/boot3"; }
      { devices = [ "/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V6GMXTYS"]; path = "/boot4"; }
    ];
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
  # Set your time zone.
  time.timeZone = "Europe/Paris";

users.users = {
    irotnep = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHb8ORNUIJkwUACMl59CvbqJJ2dFVL2QYDtJhAgehKRQSW87nU2GtAc/23ncC7BsDJMolAare3gDODpcfxlDcrHOG6O9FQmakEY0AMRO0Wk4uJHRCCPjxyYLoRUNKOUjmpY6JEG+ZzKjRGqMcvH19PmzUOkR2thdJBJ8tluXEk/UraFoSJUcA8dRxou2o9jdLtTPJIRyZNkhiRXrnD+8rD6a+VqM2JWqTqg/Mgj6EaZHyXcg2xAtXHEbVl5MIAbWPwCz2DjVNp52dEe3GyUFdlFr8Rp7TVPfA8qe+hbrs2V+ubdgEAFxQBfsSoY9UPjhdO8Yl3nhqNvXOKRTQ+EJLdlGobJUG2blrAyleyREomSixOIf6LM6HwdRxPz1QzGf8kKvqyIWtzR/s7xoV3ELLTzxyrUZF9yLrRYbdlqnxIKErb6lrwB3WUIAaT7ZQdJpRZvM5kNPg3Z2ZQZzs7SdQ/d3N4CYptr+mXHOze2cazE6DYyCshk9E4C70pBMejfaRM8RCjky6jDkODNKvu9sJXtKHyX7QceSnK83jPE/1taDLhOfFxezcqSNATtATENd8D6ulTTxflWU+cxfsCEoAUIaat5ORINYFsLlxdf3VUAKZNNmWiEB7cWKzdXbiRuqSpTAyuIxdFpFCe3GrM2R+LunsEmx/qWsDyhYjU0t7C7w== irotnep@proton.me"
      ];
      extraGroups = ["wheel" "networkmanager" "nimbus" "geth"];
    };
  };
  networking = {
    hostName = "hyperion";
    hostId = "8425e349";
    interfaces.eth0.ipv4.addresses = [{
      address = "149.202.75.222";
      prefixLength = 24;
    }];
    defaultGateway = "149.202.75.254";
    nameservers = ["8.8.8.8"];
  };
    services.openssh = {
    enable = true;
    settings = {
      passwordauthentication = true;
      allowusers = [ "irotnep" ];
      usedns = true;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 22 ];
    enable = true;
  };

  nix.settings = {
    trusted-users = ["root" "irotnep" ];
    experimental-features = [ "nix-command" "flakes" ];
  };
  system.stateVersion = "24.05"; # Did you read the comment?
}
```

Launch the installation:

```bash
nixos-install --root /mnt
```

Unmount the volumes and reboot to the new installed host
```bash
umount /mnt/boot1 /mnt/boot2 /mnt/boot3 /mnt/boot4 /mnt/nix /mnt/home /mnt/
reboot
```

## Troubleshooting

* Grub installation didn't worked with  ext4 partition.
* Grub installation failed due to `error: will not proceed with blocklists`. The option `boot.loader.grub.forceInstall` had to be added.
