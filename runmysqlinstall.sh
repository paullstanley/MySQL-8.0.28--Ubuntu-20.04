#!/bin/bash

# Set the root password
root_password="root"

# Step 1: Run apt update
#sudo apt update

# Step 2: Download MySQL 8.0.28
cd /tmp
wget -c https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-server_8.0.28-1ubuntu20.04_amd64.deb-bundle.tar

# Step 3: Extract the downloaded archive
tar -xvf mysql-server_8.0.28-1ubuntu20.04_amd64.deb-bundle.tar

# Step 4: Install dependancies
sudo apt install -y libaio1 libmecab2:amd64 <<EOF
yes
EOF

# Step 5: Set the root password in debconf
sudo echo "UNREGISTER mysql-community-server/data-dir" | sudo debconf-communicate mysql-community-server

export DEBIAN_FRONTEND="noninteractive"

sudo echo "mysql-community-server mysql-community-server/root-pass password $root_password" | sudo debconf-set-selections
sudo echo "mysql-community-server mysql-community-server/re-root-pass password $root_password" | sudo debconf-set-selections
sudo echo "mysql-community-server mysql-community-server/new-auth-types select Ok" | sudo debconf-set-selections
sudo echo "mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)" | sudo debconf-set-selections
sudo echo "mysql-community-server mysql-community-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)" | sudo debconf-set-selections


# Step 6: Install MySQL
sudo dpkg -i mysql-common_8.0.28-1ubuntu20.04_amd64.deb
sudo dpkg -i mysql-community-client-plugins_8.0.28-1ubuntu20.04_amd64.deb
sudo dpkg -i mysql-community-client-core_8.0.28-1ubuntu20.04_amd64.deb
sudo dpkg -i mysql-community-client_8.0.28-1ubuntu20.04_amd64.deb 
sudo dpkg -i mysql-client_8.0.28-1ubuntu20.04_amd64.deb
sudo dpkg -i mysql-community-server-core_8.0.28-1ubuntu20.04_amd64.deb
sudo dpkg -i mysql-community-server_8.0.28-1ubuntu20.04_amd64.deb

# Step 7: Start MySQL as service
sudo systemctl daemon-reload
sudo systemctl start mysql.service

# Step 8: Stop MySQL from auto-updating
sudo apt-mark hold mysql-server
sudo apt-mark hold mysql-common
sudo apt-mark hold mysql-server-core-*
sudo apt-mark hold mysql-client-core-*
