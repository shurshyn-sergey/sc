#!/bin/bash

curr_dir=$(pwd)

find ./bin -type f -exec chmod u+x {} \;

SC='/usr/local/sc'
mkdir $SC

cp -R "$curr_dir"/* "$SC"

# Configuring system env
echo "export SC='$SC'" > /etc/profile.d/sc.sh
chmod 755 /etc/profile.d/sc.sh
source /etc/profile.d/sc.sh
echo 'PATH=$PATH:'$SC'/bin' >> /root/.bash_profile
echo 'export PATH' >> /root/.bash_profile
source /root/.bash_profile


apt install software-properties-common
add-apt-repository ppa:ondrej/php
apt update

apt install php7.4 php7.4-fpm
apt install -y php7.4-cli php7.4-common php7.4-json php7.4-curl php7.4-dom php7.4-intl php7.4-mbstring php7.4-mysqli php7.4-mysqlnd php7.4-SimpleXML php7.4-xml php7.4-xmlreader php7.4-xmlwriter php7.4-xsl php7.4-zip php7.4-gd php7.4-bcmath

apt install php8.1 php8.1-fpm
apt install -y php8.1-cli php8.1-common  php8.1-curl php8.1-dom php8.1-intl php8.1-mbstring php8.1-mysqli php8.1-mysqlnd php8.1-SimpleXML php8.1-xml php8.1-xmlreader php8.1-xmlwriter php8.1-xsl php8.1-zip php8.1-gd php8.1-bcmath

apt install php8.2 php8.2-fpm
apt install -y php8.2-cli php8.2-common  php8.2-curl php8.2-dom php8.2-intl php8.2-mbstring php8.2-mysqli php8.2-mysqlnd php8.2-SimpleXML php8.2-xml php8.2-xmlreader php8.2-xmlwriter php8.2-xsl php8.2-zip php8.2-gd php8.2-bcmath

apt install redis-server

./bin/sc-redis-config

apt install mysql-server
systemctl start mysql.service



