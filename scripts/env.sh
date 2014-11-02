#!/bin/bash

# creates .env, .htaccess, empty db with permissions
# @saftsaak
# v1.0

name=$1 #pass repository as argument
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $scriptdir/..

tld=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['tld']);")
rootpw=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['mysqlrootpw']);")
sitesdir=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['dirname']);")

cd $sitesdir/$name

# function to generate random strings of a given length
function genpasswd() {
  local l=$1
    [ "$l" == "" ] && l=24
    openssl rand -hex $l | xargs
}

# create .env
dbpassw=$(genpasswd 6)

env+="DB_NAME="$name"\n"
env+="DB_USER="$name"\n"
env+="DB_PASSWORD="$dbpassw"\n"
env+="DB_HOST=127.0.0.1\n\n"

env+="WP_ENV=development\n"
# env+="WP_HOME=http://"$name.$tld.$(ipconfig getifaddr en0)"\n"
# env+="WP_SITEURL=http://"$name.$tld.$(ipconfig getifaddr en0)"/wp\n\n"
env+="WP_HOME=http://"$name.$tld"\n"
env+="WP_SITEURL=http://"$name.$tld"/wp\n\n"

env+="AUTH_KEY='$(genpasswd 32)'\n"
env+="SECURE_AUTH_KEY='$(genpasswd 32)'\n"
env+="LOGGED_IN_KEY='$(genpasswd 32)'\n"
env+="NONCE_KEY='$(genpasswd 32)'\n"
env+="AUTH_SALT='$(genpasswd 32)'\n"
env+="SECURE_AUTH_SALT='$(genpasswd 32)'\n"
env+="LOGGED_IN_SALT='$(genpasswd 32)'\n"
env+="NONCE_SALT='$(genpasswd 32)'"

echo -e $env > .env

echo ".env file written"

# create .htaccess
htaccess+="<IfModule mod_rewrite.c>\n"
htaccess+="  RewriteEngine On\n"
htaccess+="  RewriteBase /\n"
htaccess+="  RewriteRule ^index\.php$ - [L]\n"
htaccess+="  RewriteCond %{REQUEST_FILENAME} !-f\n"
htaccess+="  RewriteCond %{REQUEST_FILENAME} !-d\n"
htaccess+="  RewriteRule . /index.php [L]\n"
htaccess+="</IfModule>"

echo -e $htaccess > web/.htaccess

echo ".htaccess written"

# set up database
/usr/local/bin/mysql -uroot -p$rootpw -e "CREATE DATABASE \`$name\`;"
/usr/local/bin/mysql -uroot -p$rootpw -e "GRANT ALL PRIVILEGES ON \`$name\`.* TO '$name'@'%' IDENTIFIED BY '$dbpassw';"

echo "database & user created"