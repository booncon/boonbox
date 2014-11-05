#!/bin/bash

# helps to check the system prequisites
# @saftsaak
# v1.0

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $scriptdir/..

# tld=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['tld']);")
sitesdir=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$configs['dirname']);")

echo $sitesdir

if [ -z "$sitesdir" -a "${sitesdir+xxx}" = "xxx" ];
then
  echo '<p class="bg-danger">The configuration could not be read, please set up the config file `cp config.sample.json config.json`</p>'
else
  echo '<p class="bg-success">git installed</p>'
fi

# add some folder to the path
PATH=/usr/local/bin:$PATH
# PATH=""

# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"
else
  printf '<p class="bg-danger">ERROR: An RVM installation was not found.</p>'
fi

echo '<div class="well well-sm"><h4>Testing git</h4>'
if ! which git >/dev/null
then
  echo '<p class="bg-danger">git not installed, please install: `xcode-select --install`</p></div>'
else
  echo '<p class="bg-success">git installed</p></div>'
fi

echo '<div class="well well-sm"><h4>Testing brew</h4>'
if ! which brew >/dev/null
then
  echo '<p class="bg-danger">brew not installed, please install: `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`</p></div>'
else
  echo '<p class="bg-success">brew installed</p></div>'
fi

echo '<div class="well well-sm"><h4>Testing wp-cli</h4>'
if ! which wp >/dev/null
then
  echo '<p class="bg-danger">wp-cli not installed, please install: `http://wp-cli.org`</p></div>'
else
  echo '<p class="bg-success">wp-cli installed</p></div>'
fi

echo '<div class="well well-sm"><h4>Testing MariaDB</h4>'
if ! which mysql >/dev/null
then
  echo '<p class="bg-danger">MariaDB not installed, please install: `brew install mariadb`</p></div>'
else
  echo '<p class="bg-success">MariaDB installed</p></div>'
fi

echo '<div class="well well-sm"><h4>Testing dnsmasq</h4>'
if ! grep -li '127.0.0.1' '/etc/resolver/dev' >/dev/null
then
  echo '<p class="bg-danger">dnsmasq not configured, please install: `https://github.com/booncon/boonbox/blob/master/README.md`</p></div>'
else
  echo '<p class="bg-success">dnsmasq installed</p></div>'
fi


# echo '<div class="well well-sm"><h4>Testing MariaDB</h4>'
# if ! if [ ! -d "$name" ]; then
# then
#   echo '<p class="bg-danger">MariaDB not installed, please install: `brew install mariadb`</p></div>'
# else
#   echo '<p class="bg-success">MariaDB installed</p></div>'
# fi


