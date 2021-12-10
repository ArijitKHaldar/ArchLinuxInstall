#!/bin/bash

setfont ter-132n # Setting a bigger font to help see better
timedatectl set-ntp true #Synchronising with NTP time

#Formatting the disks
mkfs.vfat -F 32 -n UEFI /dev/sdb1 # Edit this with your EFI partition /dev/sda1 or similar that you used in fdisk

mkswap -L SWAP /dev/sdb4 # Edit this with your SWAP partition /dev/sda4 or similar that you used in fdisk
swapon /dev/sdb4 # Edit this with your SWAP partition /dev/sda4 or similar that you used in fdisk

mkfs.ext4 -L ARCH /dev/sdb2
mkfs.ext4 -L HOME /dev/sdb3

mkdir /mnt/{efi,home}
mount /dev/sdb2 /mnt
mount /dev/sdb3 /mnt/home
mount /dev/sdb1 /mnt/efi

genfstab -U -p /mnt >> /mnt/etc/fstab

pacstrap -i /mnt base
arch-chroot /mnt

pacman -S linux linux-headers linux-firmware

pacman -S vim base-devel openssh git ssh networkmanager network-manager-applet wpa_supplicant wireless_tools netctl dialog grub efibootmgr os-prober mtools dosfstools reflector xdg-utils xdg-user-dirs alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion rsync acpi acpi_call ipset firewalld ntfs-3g

#pacman -S intel-ucode                           # Uncomment this line if you have intel CPU
#pacman -S amd-ucode                             # Uncomment this line if you have AMD CPU
#pacman -S nvidia nvidia-utils nvidia-settings   # Uncomment this line if you have NVIDIA GPU

systemctl enable sshd
systemctl enable NetworkManager

mkinitcpio -p linux
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

passwd # This will prompt you to set your root password

useradd -m -g users -G wheel arijit # Edit my name and enter your user name of choice here
passwd arijit # Edit my name and enter your user name of choice here (This will prompt you to set user password, i.e., sudo password for your user)

sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

hwclock --systohc
echo "HOSTNAME" >> /etc/hostname    # Edit HOSTNAME in these lines to any name you want your device to be named, Eg. ArchLAPTOP

echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	HOSTNAME.localdomain	HOSTNAME" >> /etc/hosts

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=Arch_Linux --recheck
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

echo "GRUB_DISABLE_OS_PROBER=true" >> /etc/default/grub    # Set this to false if you are installing on top of Windows
grub-mkconfig -o /boot/grub/grub.cfg

exit
umount -l /mnt
echo "Shutdown and remove your bootable USB, then restart"
echo "Shutting Down..."
shutdown -h now