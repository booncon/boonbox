#!/bin/bash

# fetches assets/ db pull from staging
# @saftsaak
# v1.0

name=$1 #pass repository as argument
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $scriptdir/..

tld=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['tld']);")
rootpw=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['mysqlrootpw']);")
sitesdir=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['dirname']);")
email=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['email']);")
wpdefaultpw=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['wpdefaultpw']);")
wpdefaultuser=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['wpdefaultuser']);")

cd $sitesdir

if [ ! -d "$name" ]; then
  PATH=/usr/local/bin:$PATH
  composer create-project roots/bedrock $sitesdir/$name <<-EOF
Y
EOF
  cd $name
  # clone the roots sass theme
  git clone https://github.com/roots/roots-sass.git web/app/themes/$name
  rm -rf web/app/themes/$name/.git
  
  #create the theme style.css content
  themeInfo="/*\n"
  themeInfo+="Theme Name:         "$name" Theme\n";
  themeInfo+="Theme URI:          http://roots.io/starter-theme/\n";
  themeInfo+="Description:        This theme is based on the Roots starter theme based on HTML5 Boilerplate & Bootstrap. <a href=\"https://github.com/roots/roots/contributors\">Contribute on GitHub</a>\n";
  themeInfo+="Version:            1.0.0\n";
  themeInfo+="Author:             booncon PIXELS\n";
  themeInfo+="Author URI:         http://pixels.fi/\n\n";

  themeInfo+="License:            MIT License\n";
  themeInfo+="License URI:        http://opensource.org/licenses/MIT";
  themeInfo+="*/";

  echo -e $themeInfo > web/app/themes/$name/style.css
  echo "theme style.css written"

  # Overwrite the deploy scripts
  cp $scriptdir/../templates/README.example.md README.md
  cp $scriptdir/../templates/deploy.example.rb config/deploy.rb
  cp $scriptdir/../templates/staging.example.rb config/deploy/staging.rb

  # search and replace in the files: example_project -> project name
  sed 's/example-project/'$name'/g' config/deploy.rb > config/deploy-tmp.rb
  mv config/deploy-tmp.rb config/deploy.rb
  sed 's/example-project/'$name'/g' README.md > README-tmp.md
  mv README-tmp.md README.md

  # calling the script to set up the db and .env
  $scriptdir/env.sh $name

  # set proper path for wp-cli
  PATH=$(pwd)/vendor/wp-cli/wp-cli/bin:/usr/local/bin:$PATH

  # install wordpress and activate the roots theme
  wp core install --url=$name.$tld --title=$name --admin_user=$wpdefaultuser --admin_password=$wpdefaultpw --admin_email=$email
  wp theme activate $name
  wp option set permalink_structure /%postname%/

  # runs and npm install
  $scriptdir/npm.sh $name

  git init
  git add -A
  git commit -am "intial commit"
  git remote add origin git@github.com:booncon/$name.git
  
  echo 'The project has been created :)'
  exit 0
else 
  echo 'Sorry, it seems like this project already exists..'
  exit 1
fi