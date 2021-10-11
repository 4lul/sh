# Add SSH
apk add openssh
rc-update add sshd

# (INSECURE) Allow password authentication via SSH
sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config

read -p "Enter username add to sshd_config: " username
echo "AllowUsers $username" >> /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config

# Start SSH
/etc/init.d/sshd start

lbu commit -d
