read -p "Enter username of account to create: " username

# Add user, set password and enable terminal login
adduser -g "Linux User,,," $username
echo "$username ALL=(ALL) ALL" > /etc/sudoers.d/$username && chmod 0440 /etc/sudoers.d/$username

# (INSECURE) Allow password authentication via SSH
sed -i -e 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
echo "AllowUsers $username" >> /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config

