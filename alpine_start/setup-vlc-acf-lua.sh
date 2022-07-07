apk add vlc-daemon vlc-dev
setup-acf
apk add acf-vlc-daemon

read -p "Enter username of account to create local lua http files for vlc: " user
mkdir -p /home/$user/.local/share/vlc/lua/http
cp -r ./vlc-lua-http/* /home/$user/.local/share/vlc/lua/http

echo "VLC_OPTS='-I http --http-port 16048 --http-password rasp \
    --novideo --no-sout-video --network-caching=15000'" >> /etc/conf.d/vlc

# Start it up
/etc/init.d/vlc start
rc-update add vlc-daemon default


