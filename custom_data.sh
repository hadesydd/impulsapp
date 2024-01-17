#!/bin/bash
# install ansible
sudo apt-get update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install python3 -y
sudo apt install ansible -y
sudo apt install ansible-core -y
ansible --version
git clone https://github.com/hadesydd/impulsapp.git
export IMPULSAPP_PATH=$(pwd)/impulsapp/playbook
source ~/.bashrc
cd $IMPULSAPP_PATH
chmod +x *.sh
user_home="$HOME"
vhost_path="impulsapp/vhost"
export full_path="$user_home/$vhost_path"
source ~/.bashrc
ansible-playbook -i localhost php.yml
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt -y install nodejs npm
 
sudo sed -n '80p' /var/lib/cloud/instance/user-data.txt >> $IMPULSAPP_PATH/vars.yml
ansible-playbook -i localhost test.yml
ansible-playbook -i localhost create.yml
ansible-playbook -i localhost apache.yml
ansible-playbook -i localhost vhost.yml

cd /var/www/html/




sudo sed -n '80,103p' /var/lib/cloud/instance/user-data.txt >> /var/www/html/back-end/.env
sudo sed -n '70p' /var/lib/cloud/instance/user-data.txt >> /var/www/html/front-end/.env
cd /var/www/html/back-end
sudo chown -R superuser:superuser /var/www/html/back-end
sudo chown -R superuser:superuser /var/www/html/front-end
if command -v apt-get &>/dev/null; then
    sudo apt-get update
    sudo apt-get install -y acl
else
    echo "Unsupported package manager. Please install 'acl' manually."
    exit 1
fi
HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d ' ' -f 1)
sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var
sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo composer self-update

composer install
cd /var/www/html/front-end
rm -rf node_modules
rm package-lock.json
npm install 
npm install @material-ui/core
npm start build
npm run start   
php /var/www/html/back-end/bin/console cache:clear


















































