#!/bin/bash
installation=0
while [[ $installation != "proxy" || $installation != "webserver" || $installation != "mysql" || $installation != "phpmyadmin" ]]; do
    read -p "Que quieres instalar? (proxy|webserver|mysql|phpmyadmin)" installation
done
apt update
if [[ $installation = "proxy" ]]; then
    apt install apache2 -y
    a2enmod proxy 
    a2enmod proxy_http 
    a2enmod proxy_ajp 
    a2enmod rewrite 
    a2enmod deflate 
    a2enmod headers 
    a2enmod proxy_balancer 
    a2enmod proxy_connect 
    a2enmod proxy_html 
    a2enmod lbmethod_byrequests
    read -p "Dominio o IP del servidor 1" server1
    read -p "Dominio o IP del servidor 2" server2
    sed -i "s|IP-HTTP-SERVER-1|$server1|g" virtualhost
    sed -i "s|IP-HTTP-SERVER-2|$server2|g" virtualhost
    cp virtualhost /etc/apache2/sites-available/000-default.conf
elif [[ $installation = "webserver" ]]; then
    apt install apache2 libapache2-mod-php php-mysql -y
    mkdir TEMP
    cd TEMP
    git clone https://github.com/framafra/UD02P04.git
    sed -i "s|root|blogelin|g" UD02P04/admin/core/controller/Database.php
    read -p "Cuál es la IP del servidor MYSQL" mysql-server
    sed -i "s|localhost|$mysql-server|g" UD02P04/admin/core/controller/Database.php
    cp -r UD02P04/* /var/www/html/
    mv /var/www/html/index.html /var/www/html/index.html.bak
    cd ..
    rm -r TEMP
elif [[ $installation = "mysql" ]]; then
    apt install mysql-server -y
    cd TEMP
    git clone https://github.com/framafra/UD02P04.git
    mysql < UD02P04/schema.sql
    mysql < user.sql
    cp mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
    systemctl restart mysql
elif [[ $installation = "phpmyadmin" ]]; then
    apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y
fi
