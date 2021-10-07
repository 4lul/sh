apk add terminus-font kbd-bkeymaps kbd

wget -O ru-utf.map.gz https://aur.archlinux.org/cgit/aur.git/plain/ru-utf.map.gz?h=kbd-ru-keymaps
mv ru-utf.map.gz /usr/share/keymaps/xkb

lbu include /usr/share/keymaps/xkb/ru-utf.map.gz 

sed -i '/unicode="NO"/s/"NO"/"YES"/g' /etc/rc.conf
sed -i '/^#unicode*/s/^#//g' /etc/rc.conf
sed -i '/^#cons*=*/s/^#//g' /etc/conf.d/consolefont
sed -i '/consolefont=/s/".*"/"ter-k32n.psf.gz"/g' /etc/conf.d/consolefont
sed -i '/consoletr*=*/s/".*"/"koi8-r_to_uni.trans"/g' /etc/conf.d/consolefont

rc-update add consolefont boot

sed -i 's/keymap="us"/keymap="ru-utf"/' /etc/conf.d/loadkeys
sed -i 's/dumpkeys_charset="no"/dumpkeys_charset="yes"/' /etc/conf.d/loadkeys

rc-update add loadkeys boot

rc-service consolefont restart
rc-service loadkeys restart

#lbu commit -d
