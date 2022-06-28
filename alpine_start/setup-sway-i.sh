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

