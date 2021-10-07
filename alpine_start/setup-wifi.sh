apk add wireless-tools wpa_supplicant
ip link
ip link set wlan0 up
iwlist wlan0 scanning
iwlist wlan0 scanning | grep "ESSID"
iwconfig wlan0 essid TP-LINK_9D04_5G
iwconfig wlan0 
wpa_passphrase 'TP-LINK_9D04_5G' 'qq342675' > /etc/wpa_supplicant/wpa_supplicant.conf
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
udhcpc -i wlan0

