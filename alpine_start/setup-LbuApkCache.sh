echo "/dev/sdc1 /media/sdc1 ext4 noatime,ro 0 0" >> /etc/fstab
mount -a
setup-lbu sdc1
setup-apkcache /media/sdc1/cache

lbu commit -d
