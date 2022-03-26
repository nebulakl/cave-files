#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

echo "Determining active kernel partition from cmdline..."
kpartuuid=$(grep -oP '(?<=root\=PARTUUID=).*(?=\/PARTNROFF)' /proc/cmdline)
echo ${kpartuuid}

echo "Locating linux kernel..."
bzImage=$(pacman -Ql linux-chromebook-cave | grep -o -P '(?<= ).*vmlinuz')
echo ${bzImage}

echo "Building cmdline..."
echo "init=/sbin/init root=PARTUUID=%U/PARTNROFF=1 rootwait rw noinitrd tpm_tis.interrupts=0" > /tmp/${kpartuuid}.cmdline

if [ -f /boot/cmdline.append ]; then
    echo "/boot/cmdline.append found, appending to /tmp/${kpartuuid}.cmdline..."
    cat /boot/cmdline.append >> /tmp/${kpartuuid}.cmdline
fi

cat /tmp/${kpartuuid}.cmdline

echo "Packaging kernel partition image..."

kernel=/tmp/${kpartuuid}.img

echo " " > /tmp/${kpartuuid}.bootloader
futility vbutil_kernel --pack ${kernel} \
  --keyblock /usr/share/vboot/devkeys/kernel.keyblock \
  --signprivate /usr/share/vboot/devkeys/kernel_data_key.vbprivk \
  --version 1  --arch x86\
  --vmlinuz ${bzImage} \
  --bootloader /tmp/${kpartuuid}.bootloader \
  --config /tmp/${kpartuuid}.cmdline

echo "Writing ${kernel} to /dev/disk/by-partuuid/${kpartuuid}"

dd if=${kernel} of=/dev/disk/by-partuuid/${kpartuuid} bs=4M status=progress
sync