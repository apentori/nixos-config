#!/usr/bin/env bash

export DISK1=/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V6H00B9S
export DISK2=/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V1JUHSKH
export DISK3=/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V1HML8LH
export DISK4=/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V6GMXTYS


format() {
  parted -s --align optimal "$1" -- mklabel gpt
  parted -s --align optimal "$1" -- mkpart 'EFI'  1MiB 1GiB set 2 esp on
  parted -s --align optimal "$1" -- mkpart 'SWAP' 1GiB 17GiB set 2 esp on
  parted -s --align optimal "$1" -- mkpart 'ZFS'  17GiB '100%'
  parted -s --align optimal "$1" -- print

  mkfs.fat -F 32 -n boot $1-part1
  mkswap $1-part2
  swapon $1-part2

}


format $DISK1
format $DISK2
format $DISK3
format $DISK4

zpool create -f -O mountpoint=legacy \
    -O acltype=posixacl \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O atime=off \
    -O xattr=sa \
    zpool mirror $DISK1-part3 $DISK2-part3 $DISK3-part3 $DISK4-part3

zfs create -o quota=50G -o reservation=50G zpool/root
zfs create -o quota=50G -o reservation=50G zpool/nix
zfs create -o quota=20G -o reservation=20G zpool/home
zfs create -o quota=1.5T -o reservation=1.5T zpool/data

mount -t zfs zpool/root /mnt
mkdir /mnt/home/ /mnt/nix /mnt/boot1 /mnt/boot2 /mnt/boot3 /mnt/boot4 /mnt/data
mount -t zfs zpool/home /mnt/home
mount -t zfs zpool/nix /mnt/nix
mount -t zfs zpool/data /mnt/data
mount $DISK1-part1 /mnt/boot1
mount $DISK2-part1 /mnt/boot2
mount $DISK3-part1 /mnt/boot3
mount $DISK4-part1 /mnt/boot4

nixos-generate-config --root /mnt

nix-channel --list
nix-channel --add https://nixos.org/channels/nixos-24.05 nixos
nix-channel --update
