#!/bin/bash

# creates db with permissions
# @saftsaak
# v1.0

name=$1 # pass repository as argument
dbpassw=$2 # pass user password as argument
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $scriptdir/..

rootpw=$(php -r "\$config = json_decode(utf8_encode(file_get_contents('config.json')), true); print_r(\$config['mysqlrootpw']);")

# set up database
mysql -uroot -p$rootpw -e "CREATE DATABASE IF NOT EXISTS \`$name\`;"
mysql -uroot -p$rootpw -e "GRANT ALL PRIVILEGES ON \`$name\`.* TO '$name'@'%' IDENTIFIED BY '$dbpassw';"

echo "database & user created"