#!/bin/bash

# fetches assets/ db pull from staging
# @saftsaak
# v0.8

rootpw=root # password for mysql root user
sitesdir=/www/sites # directory of the local websites

# ----------------------- Don't change things below :) ------------------------ #

name=$1

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