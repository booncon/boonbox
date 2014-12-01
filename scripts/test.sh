#!/bin/bash

# helps to check the system prequisites
# @saftsaak
# v1.0

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $scriptdir/..

configexists=$(php -r "print file_exists('config.json');")
sitesdir=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['dirname']);")
user=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['username']);")


if [ ! $configexists ]
then
  echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> The configuration could not be read, please set up the config file `cp config.sample.json config.json`</p>'
else
  # add some folder to the path
  PATH=/usr/local/sbin:/usr/local/bin:$PATH

  if [ ! -d $sitesdir ]
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> sites directory does not exist, please create `mkdir /www/sites`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> sites directory exists</p>'
  fi

  if [ ! -f '/private/etc/apache2/httpd.conf' ]
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> httpd.conf does not exist, please create</p>'
  else
    httpdconf='<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> httpd.conf exists</p><div class="inset-wrap">'
    if grep -li '#LoadModule php5_module libexec/apache2/libphp5.so' '/private/etc/apache2/httpd.conf' >/dev/null
    then
      httpdconf+='<p class="bg-danger inset"><span class="glyphicon glyphicon-remove"> </span> uncomment `LoadModule php5_module libexec/apache2/libphp5.so`</p>'
    else
      httpdconf+='<p class="bg-success inset"><span class="glyphicon glyphicon-ok"> </span> LoadModule php5_module libexec/apache2/libphp5.so</p>'
    fi

    if grep -li '#LoadModule rewrite_module libexec/apache2/mod_rewrite.so' '/private/etc/apache2/httpd.conf' >/dev/null
    then
      httpdconf+='<p class="bg-danger inset"><span class="glyphicon glyphicon-remove"> </span> uncomment `LoadModule rewrite_module libexec/apache2/mod_rewrite.so`</p>'
    else
      httpdconf+='<p class="bg-success inset"><span class="glyphicon glyphicon-ok"> </span> LoadModule rewrite_module libexec/apache2/mod_rewrite.so</p>'
    fi

    if grep -li '#Include /private/etc/apache2/extra/httpd-vhosts.conf' '/private/etc/apache2/httpd.conf' >/dev/null
    then
      httpdconf+='<p class="bg-danger inset"><span class="glyphicon glyphicon-remove"> </span> uncomment `Include /private/etc/apache2/extra/httpd-vhosts.conf`</p>'
    else
      httpdconf+='<p class="bg-success inset"><span class="glyphicon glyphicon-ok"> </span> Include /private/etc/apache2/extra/httpd-vhosts.conf</p>'
    fi

    if grep -li 'User _www' '/private/etc/apache2/httpd.conf' >/dev/null
    then
      httpdconf+='<p class="bg-danger inset"><span class="glyphicon glyphicon-remove"> </span> change User _www to `User '$user'`</p>'
    else
      httpdconf+='<p class="bg-success inset"><span class="glyphicon glyphicon-ok"> </span> Apache User is '$user'</p>'
    fi

    if grep -li 'Group _www' '/private/etc/apache2/httpd.conf' >/dev/null
    then
      httpdconf+='<p class="bg-danger inset"><span class="glyphicon glyphicon-remove"> </span> change Group _www to `Group '$(ls -l $sitesdir/.. | grep sites | awk '{print $4}')'`</p>'
    else
      httpdconf+='<p class="bg-success inset"><span class="glyphicon glyphicon-ok"> </span> Apache Group is '$(ls -l $sitesdir/.. | grep sites | awk '{print $4}')'</p>'
    fi

    if ! grep -li '# <Directory />' '/private/etc/apache2/httpd.conf' >/dev/null
    then
      httpdconf+='<p class="bg-danger inset"><span class="glyphicon glyphicon-remove"> </span> comment out &lt;Directory \&gt; block</p></div>'
    else
      httpdconf+='<p class="bg-success inset"><span class="glyphicon glyphicon-ok"> </span> &lt;Directory /&gt; is commented out</p></div>'
    fi
    echo $httpdconf
  fi

  if [ ! -f '/etc/php.ini' ]
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> php.ini does not exist, please create `cp /etc/php.ini.default /etc/php.ini`</p>'
  else
    phpini='<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> php.ini exists</p><div class="inset-wrap">'
    if ! grep -li 'post_max_size = 256M' '/etc/php.ini' >/dev/null
    then
      phpini+='<p class="bg-danger inset"><span class="glyphicon glyphicon-remove"> </span> set `post_max_size = 256M`</p>'
    else
      phpini+='<p class="bg-success inset"><span class="glyphicon glyphicon-ok"> </span> post_max_size = 256M</p>'
    fi

    if ! grep -li 'upload_max_filesize = 256M' '/etc/php.ini' >/dev/null
    then
      phpini+='<p class="bg-danger inset"><span class="glyphicon glyphicon-remove"> </span> set `upload_max_filesize = 256M`</p>'
    else
      phpini+='<p class="bg-success inset"><span class="glyphicon glyphicon-ok"> </span> upload_max_filesize = 256M</p>'
    fi

    if ! grep -li 'display_startup_errors = On' '/etc/php.ini' >/dev/null
    then
      phpini+='<p class="bg-danger inset"><span class="glyphicon glyphicon-remove"> </span> set `display_startup_errors = On`</p>'
    else
      phpini+='<p class="bg-success inset"><span class="glyphicon glyphicon-ok"> </span> display_startup_errors = On</p>'
    fi

    if ! grep -li 'display_errors = On' '/etc/php.ini' >/dev/null
    then
      phpini+='<p class="bg-danger inset"><span class="glyphicon glyphicon-remove"> </span> set `display_errors = On`</p>'
    else
      phpini+='<p class="bg-success inset"><span class="glyphicon glyphicon-ok"> </span> display_errors = On</p>'
    fi

    if ! grep -li 'log_errors = On' '/etc/php.ini' >/dev/null
    then
      phpini+='<p class="bg-danger inset"><span class="glyphicon glyphicon-remove"> </span> set `log_errors = On`</p></div>'
    else
      phpini+='<p class="bg-success inset"><span class="glyphicon glyphicon-ok"> </span> log_errors = On</p></div>'
    fi
    echo $phpini
  fi

  if ! grep -li 'home.dev' '/private/etc/apache2/extra/httpd-vhosts.conf' >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> update the vhosts config `https://github.com/booncon/boonbox/blob/master/README.md`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> vhosts configured</p>'
  fi

  if ! grep -li '127.0.0.1' '/etc/resolver/dev' >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> dnsmasq not configured, please install: `https://github.com/booncon/boonbox/blob/master/README.md`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> '$(dnsmasq -version | head -n 1)' installed</p>'
  fi

  if ! which mysql >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> MariaDB not installed, please install: `brew install mariadb`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> '$(mysql --version)' installed</p>'
  fi

  if ! ssh -q bc-grunt@stage.bcon.io exit
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> no permission to access stage -> ask admin</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> shh access to stage</p>'
  fi

  echo '<h3>tools</h3>'

  # Load RVM into a shell session *as a function*
  if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
    # First try to load from a user install
    source "$HOME/.rvm/scripts/rvm"
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> '$(rvm version)' installed<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'$(ruby -version)' loaded</p>'
  elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
    # Then try to load from a root install
    source "/usr/local/rvm/scripts/rvm"
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> '$(rvm version )' installed<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'$(ruby -version)' loaded</p>'
  else
    printf '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> ERROR: An RVM installation was not found.</p>'
  fi

  if ! which git >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> git not installed, please install: `xcode-select --install`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> '$(git --version)' installed</p>'
  fi

  if ! which brew >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> brew not installed, please install: `ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> brew '$(brew --version)' installed</p>'
  fi

  if ! which wp >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> wp-cli not installed, please install: `http://wp-cli.org`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> '$(wp cli version)' installed</p>'
  fi

  if ! which npm >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> npm not installed, please install: `https://gist.github.com/isaacs/579814`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> npm '$(npm --version)' installed</p>'
  fi

  if ! which bower >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> bower not installed, please install: `npm install -g bower`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> bower '$(bower -version)' installed</p>'
  fi

  if ! which grunt >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> grunt not installed, please install: `npm install -g grunt-cli`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> '$(grunt -version)' installed</p>'
  fi

  if ! which compass >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> compass not installed, please install: `gem install compass`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> '$(compass version | head -n 1)' installed</p>'
  fi

  if ! which composer >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> composer not installed, please install: `https://getcomposer.org/download/`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> '$(composer --version)' installed</p>'
  fi

  if ! which sass >/dev/null
  then
    echo '<p class="bg-danger"><span class="glyphicon glyphicon-remove"> </span> compass not installed, please install: `gem install sass`</p>'
  else
    echo '<p class="bg-success"><span class="glyphicon glyphicon-ok"> </span> '$(sass --version)' installed</p>'
  fi
fi