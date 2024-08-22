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
mkfs.fat -F 32 -n boot  $DISK2-part1
```

Prepare Swap partitions:

```bash
mkswap $DISK1-part2
mkswap $DISK2-part2
swapon $DISK1-part2
swapon $DISK2-part2
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
    zpool mirror $DISK1-part4 $DISK2-part4
```

Create the differentes volumes:

```
zfs create -o quota=50G -o reservation=50G zpool/root
zfs create -o quota=50G -o reservation=50G zpool/nix
zfs create -o quota=20G -o reservation=20G zpool/home
```

## NixOS installation

Mount the differents partitions and ZFS Volumes

```
mount -t zfs zpool/root /mnt
mkdir /mnt/home/ /mnt/nix /mnt/boot1 /mnt/boot2
mount -t zfs zpool/home /mnt/home
mount -t zfs zpool/nix /mnt/nix
mount $DISK1-part1 /mnt/boot1
mount $DISK2-part1 /mnt/boot2
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

Launch the installation:

```bash
nixos-install --root /mnt
```

Unmount the volumes and reboot to the new installed host
```bash
umount /mnt/boot1 /mnt/boot2 /mnt/nix /mnt/home /mnt/
reboot
```

## Troubleshooting

* Grub installation didn't worked with  ext4 partition.
* Grub installation failed due to `error: will not proceed with blocklists`. The option `boot.loader.grub.forceInstall` had to be added.
