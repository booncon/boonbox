#!/bin/bash

# runs an npm install
# @saftsaak
# v1.0

name=$1 #pass repository as argument
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $scriptdir/..

sitesdir=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['dirname']);")
themeroot=$sitesdir$name/web/app/themes/$name

# add to path for npm
PATH=/usr/local/bin:$PATH

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

cd $themeroot

npm install

echo "npm installed"