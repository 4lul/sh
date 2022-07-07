sed -i '/^#/s/^#//g' /etc/apk/repositories
apk add sudo
read -p "Enter username of account to create: " username

# Add user, set password and enable terminal login
adduser -g "Linux User,,," $username
echo "$username ALL=(ALL) ALL" > /etc/sudoers.d/$username && chmod 0440 /etc/sudoers.d/$username

lbu include /home/$username
