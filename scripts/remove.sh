#!/bin/bash

# deletes a local project
# @saftsaak
# v1.0

project=$1 #pass repository as argument
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $scriptdir/..

rootpw=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['mysqlrootpw']);")
sitesdir=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['dirname']);")

cd $sitesdir

if [ -d "$project" ]; then
  # set up database & import content from staging
  mysql -uroot -p$rootpw -e "drop database \`$project\`;"
  mysql -uroot -p$rootpw -e "REVOKE ALL PRIVILEGES, GRANT OPTION FROM \`$project\`;"
  mysql -uroot -p$rootpw -e "drop user \`$project\`@'%';"
  rm -rf $sitesdir/$project
  echo 'The project has been removed :)'
  exit 0
else
  echo 'Sorry, the project' $project 'does not exist..'
  exit 1
fi