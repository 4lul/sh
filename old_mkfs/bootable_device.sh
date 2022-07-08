#If you created a new partition above, format it with a FAT32 filesystem (replacing sdU with your device name):

apk add dosfstools
mkdosfs -F32 /dev/sdU1

#Install syslinux and MBR (replacing sdU with your device name):

apk add syslinux
dd if=/usr/share/syslinux/mbr.bin of=/dev/sdU
syslinux /dev/sdU1

mount /dev/sdX1 /mnt/folder
tar xvf archive.tar -C /mnt/folder/.
extlinux --install /boot
