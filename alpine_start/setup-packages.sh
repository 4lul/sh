# Add repos
#sed -i '/^#/s/^#//g' /etc/apk/repositories
#echo "/media/sdc1/cache" >> /etc/apk/repositories

# Update packages to latest versions
apk update
apk upgrade

# Add basic tools
apk add sudo
apk add screen
cp screenrc /etc/
apk add vim
cp vimrc /root/.vimrc

#lbu commit -d
