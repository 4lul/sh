apk add eudev && \
setup-udev && \
apk add mesa-dri-gallium && \
setup-xorg-base && \
apk add xf86-video-ati && \
echo fbcon >> /etc/modules && \
echo radeon >> /etc/modules && \
apk add mkinitfs && \
echo eatures=\"keymap cryptsetup kms ata base ide scsi usb virtio ext4\" >> /etc/mkinitfs/mkinitfs.conf
mkinitfs
printf 'press [ENTER] to continue deleting...'
read _
adduser $USER input
adduser $USER video
apk add ttf-dejavu && \
apk add seatd && \
rc-update add seatd && \
rc-service seatd start && \
adduser $USER seat

