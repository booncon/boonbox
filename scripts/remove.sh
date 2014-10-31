#!/bin/bash

# deletes a local project
# @saftsaak
# v0.8

rootpw=root # password for mysql root user
sitesdir=/www/sites # directory of the local websites

# ----------------------- Don't change things below :) ------------------------ #

project=$1 #pass repository as argument

cd $sitesdir

if [ -d "$project" ]; then
  # set up database & import content from staging
  /usr/local/bin/mysql -uroot -p$rootpw -e "drop database \`$project\`;"
  /usr/local/bin/mysql -uroot -p$rootpw -e "drop user \`$project\`;"
  rm -rf $sitesdir/$project

  echo 'The project has been removed :)'
  exit 0
else
  echo 'Sorry, the project' $project 'does not exist..'
  exit 1
fi  