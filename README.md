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
  See if the pings returned without losses. Note the `UP` in green beside the adapter that your device is connecting to.


- Now check which disks are visible to the system
```
fdisk -l
```
  You must remember that your target device is not the device that you booted with. For example, if your 32 GiB flash drive is shown as `/dev/sda` and your NVMe SSD is shown as `/dev/nvme0n1` then your target device is /dev/nvme0n1.
  
  Ascertain which drive you want to format to install Arch by the size of the drive shown, and remember if it is /dev/sda or sdb or nvme0n1 etc.
  
  (I am writing this assuming your target device is /dev/sdb with 500GiB storage space and your bootable flash drive is /dev/sda. Please make necessary corrections before executing)

### Formatting the Disk
```
fdisk /dev/sdb
```
- This should put you into the fdisk utility with a `Command (m for help):` prompt.
- Type `g` and press ENTER to make a new GPT table. (If prompted with rewrite GPT confirmation, press Y to agree)


- Type `n` to make new partition.
- Press ENTER to accept the first sector as default value.
- Type `+250M` to make the last sector of size 250MB from the first sector for the first partition (This is our EFI Partition).
- Type `t` and press ENTER to change the partition type. (Accept partition number as Partition 1 if prompted)
- Type `1` and press ENTER to make First Partition as EFI System Partition.


- Type `n` to make the next partition.
- Press ENTER to accept the first sector as default value.
- Type `+120G` to make the ROOT Partition as 120 GiB.


- Type `n` to make the next partition.
- Press ENTER to accept the first sector as default value.
- Type `+370G` to make the HOME partition as 370GiB.
  