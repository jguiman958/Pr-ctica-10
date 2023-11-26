#!/bin/bash

# Muestra todos los comandos que se han ejeutado.
set -ex

# Actualización de repositorios
apt update

# Actualización de paquetes
# sudo apt upgrade  

# Invocamos al archivo source .env
source .env

# Instalamos el servidor Web apache
apt install apache2 -y

# Habilitamos los modulos para configurar Apache como proxy apache
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer

# Habilitamos el balanceo de carga round robin
a2enmod lbmethod_byrequests

# Copiamos el archivo de configuracion
cp ../conf/load-balancer.conf /etc/apache2/sites-available


# Reemplazo las variables de la plantilla con las direcciones de los frontales.
sed -i "s/IP_HTTP_SERVER_1/$IP_HTTP_SERVER_1/" /etc/apache2/sites-available/load-balancer.conf
sed -i "s/IP_HTTP_SERVER_2/$IP_HTTP_SERVER_2/" /etc/apache2/sites-available/load-balancer.conf

# hABILITAMOS EL VIRTUALhOST QUE HEMOS CREADO
a2ensite load-balancer.conf

# Deshabilitamos el virtual host por defecto.
a2dissite 000-default.conf

# Reiniciamos
systemctl restart apache2