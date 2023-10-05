#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

find "$SCRIPT_DIR"/bin -type f -exec chmod u+x {} \;

SC='/usr/local/sc'
mkdir $SC

cp -R "$SCRIPT_DIR"/* "$SC"

# Configuring system env
echo "export SC='$SC'" > /etc/profile.d/sc.sh
chmod 755 /etc/profile.d/sc.sh
source /etc/profile.d/sc.sh
echo 'PATH=$PATH:'$SC'/bin' >> /root/.bash_profile
echo 'export PATH' >> /root/.bash_profile
source /root/.bash_profile


apt -y install software-properties-common
add-apt-repository -y ppa:ondrej/php
apt update

apt install -y php7.4 php7.4-fpm
apt install -y php7.4-cli php7.4-common php7.4-json php7.4-curl php7.4-dom php7.4-intl php7.4-mbstring php7.4-mysqli php7.4-mysqlnd php7.4-SimpleXML php7.4-xml php7.4-xmlreader php7.4-xmlwriter php7.4-xsl php7.4-zip php7.4-gd php7.4-bcmath

apt install -y php8.1 php8.1-fpm
apt install -y php8.1-cli php8.1-common  php8.1-curl php8.1-dom php8.1-intl php8.1-mbstring php8.1-mysqli php8.1-mysqlnd php8.1-SimpleXML php8.1-xml php8.1-xmlreader php8.1-xmlwriter php8.1-xsl php8.1-zip php8.1-gd php8.1-bcmath

apt install -y php8.2 php8.2-fpm
apt install -y php8.2-cli php8.2-common  php8.2-curl php8.2-dom php8.2-intl php8.2-mbstring php8.2-mysqli php8.2-mysqlnd php8.2-SimpleXML php8.2-xml php8.2-xmlreader php8.2-xmlwriter php8.2-xsl php8.2-zip php8.2-gd php8.2-bcmath


apt install -y fail2ban
fban_config=/etc/fail2ban/jail.local
cp /etc/fail2ban/jail.conf "$fban_config"
sed -i -E '/\[sshd\]/{N;N;N;N;N;N;s#port.*#mode = aggressive\nport = ssh\nmaxretry = 2\nbantime = 10h#}' "$fban_config"
service fail2ban restart


apt install -y redis-server

./bin/sc-redis-config

apt install -y mysql-server
systemctl start mysql.service

apt install -y nginx

sed -i -E 's/\/var\/log\/nginx.*/\/var\/log\/nginx\/*log \/var\/log\/nginx\/domains\/*log {/g' /etc/logrotate.d/nginx
sed -i -E 's/create.*/create/g' /etc/logrotate.d/nginx

# disable ssh/sftp password authentication
sed -i -E 's/PasswordAuthentication.*/PasswordAuthentication no/g' /etc/ssh/sshd_config
service sshd restart


# composer
curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php --install-dir=/usr/local/bin --filename=composer


"$SC"/bin/sc-add-sys-sftp-jail

#"$SC"/bin/sc-add-sudo-user dm-deployer

#mysql --execute="ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';"
#mysql_secure_installation

#mysql --execute "UPDATE mysql.user SET Password=PASSWORD('') WHERE User='root';";
mysql --execute "DELETE FROM mysql.user WHERE User='';";
mysql --execute "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');";
mysql --execute "DROP DATABASE IF EXISTS test;";
mysql --execute "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';";
mysql --execute "FLUSH PRIVILEGES;";

# iptables

#iptables -I INPUT -p tcp --dport 80 -j ACCEPT
#iptables -I INPUT -p tcp --dport 443 -j ACCEPT
#iptables -I INPUT -p tcp --dport 22 -j ACCEPT
#iptables -A INPUT -p tcp -j DROP