#!/bin/bash

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

user_home="$HOME"
vhost_path="impulsapp/vhost"
full_path="$user_home/$vhost_path"
source ~/.bashrc




ansible-playbook -i localhost test.yml
ansible-playbook -i localhost create.yml
ansible-playbook -i localhost apache.yml
ansible-playbook -i localhost vhost.yml
#echo "admin_password: $(tr -dc A-Za-z0-9 < /dev/urandom | head -c 16)" >> vars.yml