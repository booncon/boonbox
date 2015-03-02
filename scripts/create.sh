#!/bin/bash

# fetches assets/ db pull from staging
# @saftsaak
# v1.1

name=$1 #pass repository as argument
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $scriptdir/..

tld=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['tld']);")
rootpw=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['mysqlrootpw']);")
sitesdir=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['dirname']);")
email=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['email']);")
wpdefaultpw=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['wpdefaultpw']);")
wpdefaultuser=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['wpdefaultuser']);")
themeroot=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['themeroot']);")
themerepo=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['themerepo']);")

cd $sitesdir

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

if [ ! -d "$name" ]; then
  PATH=/usr/local/bin:$PATH
  composer create-project roots/bedrock $sitesdir/$name <<-EOF
Y
EOF
  cd $name
  # clone the roots sass theme
  git clone $themerepo web/app/themes/$name
  rm -rf web/app/themes/$name/.git
  
  #create the theme style.css content
  themeInfo="/*\n"
  themeInfo+="Theme Name:         "$name" Theme\n";
  themeInfo+="Description:        "$name" Theme description\n";
  themeInfo+="Version:            1.0.0\n";
  themeInfo+="Author:             booncon PIXELS\n";
  themeInfo+="Author URI:         http://pixels.fi/\n\n";

  themeInfo+="License:            MIT License\n";
  themeInfo+="License URI:        http://opensource.org/licenses/MIT";
  themeInfo+="*/";

  echo -e $themeInfo > $themeroot$name/style.css
  echo "theme style.css written"

  # Overwrite the deploy scripts
  # cp $scriptdir/../templates/README.example.md $sitesdir$name/README.md
  cp $scriptdir/../templates/deploy.example.rb $sitesdir$name/config/deploy.rb
  cp $scriptdir/../templates/boonstage.example.rb $sitesdir$name/config/deploy/boonstage.rb

  # search and replace in the files: example_project -> project name
  sed -i '' 's/example-project/'$name'/g' $sitesdir$name/config/deploy.rb
  #sed -i '' 's/example-project/'$name'/g' $sitesdir$name/README.md

  sed -i '' 's/example.dev/'$name'.dev/g' $themeroot$name/assets/manifest.json 

  # fix stupid roots gitignore
  # sed -i '' 's/\*main\*/main/g' $sitesdir$name/$themeroot$name/.gitignore
  # sed -i '' 's/\*scripts\*/scripts/g' $sitesdir$name/$themeroot$name/.gitignore
  # sed -i '' '/modernizr/d' $sitesdir$name/$themeroot$name/.gitignore

  # sed -i '' 's/sourcemap: true/sourcemap: false/g' $sitesdir$name/$themeroot$name/Gruntfile.js

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

  # building the production asset files
  cd $themeroot$name
  npm cache clean
  npm install
  bower install
  gulp
  echo 'assets build successful'

  cd $sitesdir$name

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