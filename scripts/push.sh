#!/bin/bash

# fetches assets/ db pull from staging
# @saftsaak
# v1.0

name=$1 #pass repository as argument
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $scriptdir/..

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
  # push git repository to github
  if ! git push -u origin master
  then
    echo 'This git repository does not exist, please set it up.'
    exit 2
  fi  

  # install the bundle and create on staging
  bundle exec cap staging deploy:setup

  echo 'The projects has been set up on staging :)'
  exit 0
else 
  echo 'Sorry, are you sure this project is set up?!'
  exit 1
fi