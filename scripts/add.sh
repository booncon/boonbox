#!/bin/bash

# set up a roots project from github with assets/ db pull from staging
# @saftsaak
# v0.8

devTLD=.dev # tld for local dev domains
rootpw=root # password for mysql root user
sitesdir=/www/sites # directory of the local websites

# ----------------------- Don't change things below :) ------------------------ #

github=$1 #pass repository as argument
scriptdir=$(pwd)

# function to generate random strings of a given length
function genpasswd() {
  local l=$1
    [ "$l" == "" ] && l=24
    openssl rand -hex $l | xargs
}

# fetch the project name by string splitting
IFS='/' read -ra ADDR <<< "$github"
IFS='.' read -ra ADDR <<< "${ADDR[${#ADDR[@]} - 1]}"
name=${ADDR[0]}

# enter the development folder
cd $sitesdir

# only if the project does not exist already
if [ ! -d "$name" ]; then
  # clone into the project from github
  if ! /usr/bin/git clone $github
  then
      echo 'This git repository does not exist.'
      exit 2
  fi

  # enter the project folder
  cd $name

  # create .env
  dbpassw=$(genpasswd 12)

  env+="DB_NAME="$name"\n"
  env+="DB_USER="$name"\n"
  env+="DB_PASSWORD="$dbpassw"\n"
  env+="DB_HOST=127.0.0.1\n\n"

  env+="WP_ENV=development\n"
  env+="WP_HOME=http://"$name$devTLD"\n"
  env+="WP_SITEURL=http://"$name$devTLD"/wp\n\n"

  env+="AUTH_KEY='$(genpasswd 32)'\n"
  env+="SECURE_AUTH_KEY='$(genpasswd 32)'\n"
  env+="LOGGED_IN_KEY='$(genpasswd 32)'\n"
  env+="NONCE_KEY='$(genpasswd 32)'\n"
  env+="AUTH_SALT='$(genpasswd 32)'\n"
  env+="SECURE_AUTH_SALT='$(genpasswd 32)'\n"
  env+="LOGGED_IN_SALT='$(genpasswd 32)'\n"
  env+="NONCE_SALT='$(genpasswd 32)'"

  echo -e $env > .env

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

  #install wordpress and other dependencies
  /usr/local/bin/composer install

  # set up database
  /usr/local/bin/mysql -uroot -p$rootpw -e "create database \`$name\`;"
  /usr/local/bin/mysql -uroot -p$rootpw -e "GRANT ALL PRIVILEGES  ON \`$name\`.* TO '$name'@'%' IDENTIFIED BY '$dbpassw';"
  
  echo 'The project has been set up :)'
  exit 0
else 
  echo 'Sorry, it seems like this project already exists..'
  exit 1
fi