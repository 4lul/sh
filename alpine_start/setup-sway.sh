apk add dbus-x11 eudev && \
setup-udev && \
apk add mesa-dri-gallium && \
setup-xorg-base && \
#apk add xf86-video-ati && \
#echo fbcon >> /etc/modules && \
#echo radeon >> /etc/modules && \
apk add mkinitfs && \
echo features=\"keymap cryptsetup kms ata base ide scsi usb virtio ext4\" >> /etc/mkinitfs/mkinitfs.conf
mkinitfs
read -p "Enter username: " USER
printf $USER
#printf 'press [ENTER] to continue deleting...'
read _
adduser $USER input
adduser $USER video
apk add ttf-dejavu && \
apk add seatd && \
rc-update add seatd && \
rc-service seatd start && \
adduser $USER seat && \
apk add seatd-launch && \
apk add elogind polkit-elogind && \
rc-update add elogind && \
rc-service elogind start && \
apk add sway sway-doc && \
apk add xwayland foot dmenu swaylock swaybg swayidle && \
mkdir ~/.run
#XDG_RUNTIME_DIR=~/.run dbus-launch sway
#XDG_RUNTIME_DIR=~/.run dbus-launch seatd-launch sway
#alias swayinit="XDG_RUNTIME_DIR=~/.run dbus-launch seatd-launch sway"
#swaylock needs to be able to read your /etc/shadow file to be able to validate
