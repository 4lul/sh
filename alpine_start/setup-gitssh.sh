apk add git
read -p "Enter email to create ssh rsa key: " email

ssh-keygen -t rsa -b 4096 -C $email

ssh -T git@github.com
read -p "Enter user: " guser
read -p "Enter repo: " grepo
git remote set-url origin git@github.com:$guser/$grepo.git
