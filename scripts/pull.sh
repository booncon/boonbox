#!/bin/bash

# fetches assets/ db pull from staging
# @saftsaak
# v1.0

name=$1 #pass repository as argument
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $scriptdir/..

rootpw=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['mysqlrootpw']);")
sitesdir=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['dirname']);")

cd $sitesdir/$name

# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"
else
  printf "ERROR: An RVM installation was not found.\n"
fi

# only if the project does not exist already
if [ -f Gemfile ]; then
  # fetch file and database from staging
  bundle install
  bundle exec cap staging uploads:pull
  bundle exec cap staging db:pull

  # add possible project wp-cli and global wp to the path
  PATH=$(pwd)/vendor/wp-cli/wp-cli/bin:/usr/local/bin:$PATH

  if [ -f ~/Downloads/$name.sql ]; then
    wp db import ~/Downloads/$name.sql --path=web/wp
    rm -rf ~/Downloads/$name.sql
  fi

  echo 'The files & db have been pulled :)'
  exit 0
else 
  echo 'Sorry, there is nothing to fetch?!'
  exit 1
fi