mount UUID="fb31a6b0-de6c-4de9-ad2a-be26e396a5b9" /media/usb/
apk add minidlna
echo "media_dir=/media/usb/home/pd/Downloads/" >> /etc/minidlna.conf
service minidlna start
