# Add repos
#sed -i '/^#/s/^#//g' /etc/apk/repositories
#echo "/media/sdc1/cache" >> /etc/apk/repositories

# Update packages to latest versions
apk update
apk upgrade

# Add basic tools
apk add sudo screen vim git w3m
cp .screenrc ~/.screenrc
cp .vimrc ~/.vimrc
printf "alias ls='ls --color=auto'\n" >> ~/.ashrc

lbu commit -d
