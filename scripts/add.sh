#!/bin/bash

# set up a roots project from github with assets/ db pull from staging
# @saftsaak
# v1.0

github=$1 #pass repository as argument
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $scriptdir/..

rootpw=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['mysqlrootpw']);")
sitesdir=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['dirname']);")

# add to path for npm
PATH=/usr/local/bin:$PATH

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
  if ! git clone $github
  then
      echo 'This git repository does not exist.'
      exit 2
  fi

  # enter the project folder
  cd $name

  if [ -f composer.json ]; then
    #install wordpress and other dependencies
    composer install
  fi

  # calling the script to set up the db and .env
  $scriptdir/env.sh $name

  # runs and npm install
  $scriptdir/npm.sh $name

  echo 'The project has been set up :)'
  exit 0
else 
  echo 'Sorry, it seems like this project already exists..'
  exit 1
fi