# ArchLinuxInstall
This is a quick script for installing Arch the vanilla way. I am making a more generalised version, which I hope to put here soon

## Instructions
(Please note, I am assuming here that you are using an UEFI system with US Keyboard)

- Boot into your Arch ISO in UEFI mode.
- Check if the bootable drive booted correctly in UEFI mode
```
ls /sys/firmware/efi/efivars
```
  If any output is given, your system booted correctly, else don't execute this code
- Check if your internet is working
```
ping archlinux.org -c 5
ip -c a
```
  See if the pings returned without losses. Note the 'UP' in green beside the adapter that your device is connecting to.
- Now check which disks are visible to the system
```
fdisk -l
```
  You must remember that your target device is not the device that you booted with. For example, if your 32 GiB flash drive is shown as '/dev/sda' and your NVMe SSD is shown as '/dev/nvme0n1' then your target device is /dev/nvme0n1
  