#echo "/dev/sdc1 /media/sdc1 ext4 noatime,ro 0 0" >> /etc/fstab
read -p "Lbu apk cache device (ex. sdc1): " mydevice
mount -a
setup-lbu $mydevice
setup-apkcache /media/$mydevice/cache

