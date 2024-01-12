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
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm  
nvm install 12
nvm use 12
ansible-playbook -i localhost symfony.yml
#sudo sed -n '60p' /var/lib/cloud/instance/user-data.txt >> cd $IMPULSAPP_PATH/vars.yml

ansible-playbook -i localhost apache.yml
ansible-playbook -i localhost vhost.yml

cd /var/www/html/
sudo git clone https://kcaliati-its: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@github.com/Impulsa-fr/back-end.git
sudo git clone https://kcaliati-its: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@github.com/Impulsa-fr/front-end.git




#sudo sed -n '60,84p' /var/lib/cloud/instance/user-data.txt >> /var/www/html/back-end/.env
cd /var/www/html/back-end
sudo chown -R $(whoami):$(whoami) /var/www/html/back-end
sudo chown -R $(whoami):$(whoami) /var/www/html/front-end
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
composer install
cd /var/www/html/front-end
rm -rf node_modules
rm package-lock.json
npm install @material-ui/core
npm start build
npm run start



php /var/www/html/back-end/bin/console cache:clear


































