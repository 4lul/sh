# Add repos
sed -i '/^#/s/^#//g' /etc/apk/repositories
echo "/media/mmcblk0p1/apks" >> /etc/apk/repositories

# Update packages to latest versions
apk update
apk upgrade

# Add basic tools
apk add sudo
apk add screen
apk add vim

cp vimrc /etc/vim
cp screenrc /etc

lbu commit -d
