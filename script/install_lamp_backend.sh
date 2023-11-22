#!/bin/bash

# Muestra todos los comandos que se han ejeutado.

set -ex

# Actualización de repositorios
 sudo apt update

# Actualización de paquetes
# sudo apt upgrade  

# IMPORTAMOS EL ARCHIVO .ENV
source .env

#instalar mysql server
sudo apt install mysql-server -y

# Configuración de mysql, para que solo acepte conexiones desde la ip privada.
sed -i "s/127.0.0.1/$MYSQL_PRIVATE/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciar
systemctl restart mysql

