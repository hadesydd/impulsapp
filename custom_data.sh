#!/bin/bash
set -e

# Log file for capturing output and errors
LOG_FILE="/var/log/bootstrap_script.log"

# Redirect all subsequent output and errors to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to log messages with timestamps
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting bootstrap script..."

# Add necessary repositories and install dependencies
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y python3 ansible ansible-core

# Clone the repository
git clone https://github.com/hadesydd/impulsapp.git
export IMPULSAPP_PATH=$(pwd)/impulsapp/playbook
cd $IMPULSAPP_PATH
chmod +x *.sh

# Set up environment variables
user_home="$HOME"
vhost_path="impulsapp/vhost"
export full_path="$user_home/$vhost_path"
# Run Ansible playbooks
ansible-playbook -i localhost php.yml


# Perform other setup tasks
cd /var/www/html/



# Extract and append specific lines from user-data.txt and execute other playbook
sudo sed -n '90,114p' /var/lib/cloud/instance/user-data.txt >> /var/www/html/back-end/.env
sudo sed -n '70p' /var/lib/cloud/instance/user-data.txt >> /var/www/html/front-end/.env
sudo sed -n '90p' /var/lib/cloud/instance/user-data.txt >> $IMPULSAPP_PATH/vars.yml
cd $IMPULSAPP_PATH
ansible-playbook -i localhost test.yml 
ansible-playbook -i localhost apache.yml
ansible-playbook -i localhost vhost.yml
ansible-playbook -i localhost create.yml
# Set permissions
cd /var/www/html/back-end
sudo chown -R superuser:superuser /var/www/html/back-end
sudo chown -R superuser:superuser /var/www/html/front-end
sudo sed -n '90,114p' /var/lib/cloud/instance/user-data.txt >> /var/www/html/back-end/.env
sudo sed -n '70p' /var/lib/cloud/instance/user-data.txt >> /var/www/html/front-end/.env

# Install ACL
sudo apt-get update
sudo apt-get install -y acl
# Install Composer
cd /var/www/html/back-end 
sudo curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo composer self-update
#Composer install
composer install -n
# Clear PHP cache
php /var/www/html/back-end/bin/console cache:clear



# Set ACL permissions

HTTPDUSER=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d ' ' -f 1)
sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var
sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX var

# Install front-end dependencies
cd /var/www/html/front-end
rm -rf node_modules
rm package-lock.json
npm install
npm install @material-ui/core
npm run build
npm start

log "Bootstrap script completed successfully."
































