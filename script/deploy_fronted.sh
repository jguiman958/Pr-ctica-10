#!/bin/bash

# Muestra todos los comandos que se han ejeutado.

set -ex

# Actualización de repositorios
 sudo apt update

# Actualización de paquetes
# sudo apt upgrade  

# Incluimos las variables del archivo .env.
source .env

# Borramos los archivos previos.
rm -rf /tmp/wp-cli.phar

# Descargamos La utilidad wp-cli
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

# Asignamos permisos de ejecución al archivo wp-cli.phar
chmod +x /tmp/wp-cli.phar

# Movemos los el fichero wp-cli.phar a bin para incluirlo en la lista de comandos.
mv /tmp/wp-cli.phar /usr/local/bin/wp

# Eliminamos instalaciones previas de wordpress
rm -rf /var/www/html/*

#Descargarmos el codigo fuente de wordpress en /var/www/html
wp core download --path=/var/www/html --locale=es_ES --allow-root

# Creación del archivo wp-config 
wp config create \
  --dbname=$WORDPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --path=/var/www/html \
  --allow-root

# Instalar wordpress.

wp core install \
  --url=$CERTIFICATE_DOMAIN \
  --title="$wordpress_title" \
  --admin_user=$wordpress_admin_user \
  --admin_password=$wordpress_admin_pass \
  --admin_email=$wordpress_admin_email \
  --path=/var/www/html \
  --allow-root

# Actualizamos el core
wp core update --path=/var/www/html --allow-root

# Instalamos un tema:

wp theme install sydney --activate --path=/var/www/html --allow-root

# Instalamos el plugin bbpress:

wp plugin install bbpress --activate --path=/var/www/html --allow-root

# Instalamos el plugin para ocultar wp-admin
wp plugin install wps-hide-login --activate --path=/var/www/html --allow-root

# Habilitar permalinks
 wp rewrite structure '/%postname%/' \
  --path=/var/www/html \
  --allow-root
  
# Modificamos automaticamente el nombre que establece por defecto el plugin wpd-hide-login
wp option update whl_page $WORDPRESS_HIDE_LOGIN --path=/var/www/html --allow-root


# Hbailitamos la modalidad de reescritura.
a2enmod rewrite

# Cambiamos al propietario de /var/www/html como www-data
chown -R www-data:www-data /var/www/html