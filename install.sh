#!/bin/bash

setfont ter-132n # Setting a bigger font to see better
timedatectl set-ntp true #Synchronising with NTP time
fdisk /dev/sdb # Edit this accordingly (See README file)
