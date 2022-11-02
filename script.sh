#!/bin/bash
if [[ `whoami` != 'root' ]]; then
    echo "Debes ejecutar el script como root"
    exit
fi

installation=0
while [[ $installation != "proxy" && $installation != "webserver" && $installation != "mysql" && $installation != "phpmyadmin" && $installation != "notinstall" ]]; do
    read -p "Que quieres instalar? (proxy|webserver|mysql|phpmyadmin|notinstall)" installation
done
apt update > /dev/null &> /dev/null
if [[ $installation = "proxy" ]]; then
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    echo "---------Instalando Apache Proxy------------"
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    apt install apache2 -y
    clear
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    echo "-------Habilitando Modulos Apache-----------"
    echo "--------------------------------------------"
    echo "--------------------------------------------"
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
    clear
    read -p "Dominio o IP del servidor 1" server1
    read -p "Dominio o IP del servidor 2" server2
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    echo "---Configurando archivos de configuración---"
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    mkdir TEMP
    cp virtualhost TEMP/
    cd TEMP/
    sed -i "s|IP-HTTP-SERVER-1|$server1|g" virtualhost
    sed -i "s|IP-HTTP-SERVER-2|$server2|g" virtualhost
    cp virtualhost /etc/apache2/sites-available/000-default.conf
    clear
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    echo "------Borrando archivos temporales----------"
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    cd ..
    rm -r TEMP
elif [[ $installation = "webserver" ]]; then
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    echo "----------Instalando Apache PHP-------------"
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    apt install apache2 libapache2-mod-php php-mysql -y
    clear
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    echo "-----------Configurando Apache--------------"
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    mkdir TEMP
    cd TEMP
    git clone https://github.com/framafra/UD02P04.git
    sed -i "s|root|blogelin|g" UD02P04/admin/core/controller/Database.php
    read -p "¿Cuál es la IP del servidor MYSQL? " mysql_server
    sed -i "s|localhost|$mysql_server|g" UD02P04/admin/core/controller/Database.php
    cp -r UD02P04/* /var/www/html/
    mv /var/www/html/index.html /var/www/html/index.html.bak
    cd ..
    clear
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    echo "------Borrando archivos temporales----------"
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    rm -r TEMP
elif [[ $installation = "mysql" ]]; then
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    echo "------------Instalando MYSQL----------------"
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    apt install mysql-server -y
    clear
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    echo "------------Configurando MYSQL--------------"
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    mkdir TEMP
    cd TEMP
    git clone https://github.com/framafra/UD02P04.git
    mysql < UD02P04/schema.sql
    mysql < ../user.sql
    cp ../mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
    systemctl restart mysql
    clear
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    echo "------Borrando archivos temporales----------"
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    cd ..
    rm -r TEMP
elif [[ $installation = "phpmyadmin" ]]; then
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    echo "----------Instalando PHPMyAdmin-------------"
    echo "--------------------------------------------"
    echo "--------------------------------------------"
    apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y
elif [[ $installation = "notinstall" ]]; then
    exit
fi
