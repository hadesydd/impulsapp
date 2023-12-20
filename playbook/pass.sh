#!/bin/bash

export MYSQL_ROOT_PASSWORD="admin456"

echo "Setting up MySQL login path..."
read -p "Enter MySQL root password: " -s MYSQL_ROOT_PASSWORD

mysql_config_editor set --login-path=local --host=localhost --user=root --password=${MYSQL_ROOT_PASSWORD}

echo "MySQL login path configured successfully."

