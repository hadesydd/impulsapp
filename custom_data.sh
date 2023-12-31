#!/bin/bash


# install ansible
sudo apt-get update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install python3
sudo apt install ansible -y
sudo apt install ansible-core -y
ansible --version

git clone https://github.com/hadesydd/impulsapp.git
export IMPULSAPP_PATH=$(pwd)/impulsapp/playbook
source ~/.bashrc
cd $IMPULSAPP_PATH
chmod +x *.sh

# symfony 
ansible-playbook -i localhost symfony.yml
ansible-playbook -i localhost php-cli.yml
ansible-playbook -i localhost nodejs-14.yml

mkdir -p var
if command -v apt-get &>/dev/null; then
    # Debian-based system (e.g., Ubuntu)
    sudo apt-get update
    sudo apt-get install -y acl
else
    echo "Unsupported package manager. Please install 'acl' manually."
    exit 1
fi
HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d ' ' -f 1)
sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var
sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var
apt install php-cli -y

php /var/www/html/back-end/bin/console cache:clear



user_home="$HOME"
vhost_path="impulsapp/vhost"
export full_path="$user_home/$vhost_path"
source ~/.bashrc




ansible-playbook -i localhost test.yml
ansible-playbook -i localhost create.yml
ansible-playbook -i localhost apache.yml
ansible-playbook -i localhost vhost.yml


