apk add wireless-tools wpa_supplicant
ip link
ip link set wlan0 up
iwlist wlan0 scanning
iwlist wlan0 scanning | grep "ESSID"
read -p "Enter ESSID name" essidname
iwconfig wlan0 essid $essidname
iwconfig wlan0 
read -s -p "Password: " passw
wpa_passphrase $essidname passw > /etc/wpa_supplicant/wpa_supplicant.conf
wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
udhcpc -i wlan0

