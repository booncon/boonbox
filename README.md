### A Local Home Page for OSX Web Development

This is the starting point for daily development. It is optimised for Bedrock Wordpress projects with roots themes. It allows to fetch files and db from a staging server.

Make sure you have xcode installed, agree to the tos after installing
`xcode-select --install`

Install Homebrew
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Use Homebrow to install MariaDB
`brew install mariadb`


Secure the MariaDB installation (use root as the root password)
`mysql_secure_installation`


Install and configure dnsmasq to intercept all .dev domains
```
brew install dnsmasq
cd $(brew --prefix)
mkdir etc
echo 'address=/.dev/127.0.0.1' > etc/dnsmasq.conf
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
sudo mkdir /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'
```


Set up your local development folders
```
mkdir /www
mkdir /www/home
mkdir /www/sites
cd /www/home/
git clone https://github.com/booncon/boonbox.git web
cd web
cp config.sample.json config.json //adapt the settings
```


Create a php.ini file and change some values
```
cp /etc/php.ini.default /etc/php.ini
post_max_size = 256M
upload_max_filesize = 256M
display_startup_errors = On
display_errors = On
log_errors = On
```


Start Apache and visit http://home.dev
`sudo apachectl start`


Change some lines in the Apache config
```
nano /private/etc/apache2/httpd.conf
LoadModule php5_module libexec/apache2/libphp5.so
LoadModule rewrite_module libexec/apache2/mod_rewrite.so
LoadModule vhost_alias_module libexec/apache2/mod_vhost_alias.so

#<Directory />
	#    AllowOverride none
  #    Require all denied
#</Directory>

<IfModule unixd_module>
	User sftsk //owner user of /www
	Group staff //owner group of /www
</IfModule>

ServerAdmin luki@booncon.com //your e-mail address

Include /private/etc/apache2/extra/httpd-vhosts.conf
```


Change the virtual hosts config
```
nano /private/etc/apache2/extra/httpd-vhosts.conf

<Directory "/www">
  Options Indexes MultiViews FollowSymLinks
  AllowOverride All
  Order allow,deny
  Allow from all
</Directory>

<Virtualhost *:80>
  VirtualDocumentRoot "/www/home/web"
  ServerName home.dev
  UseCanonicalName Off
</Virtualhost>

<Virtualhost *:80>
  DocumentRoot "/www/sites/tsite/docroot"
  ServerName tsite.dev
  UseCanonicalName Off
</Virtualhost>

<Virtualhost *:80>
  VirtualDocumentRoot "/www/sites/%1/web"
  ServerName sites.dev
  ServerAlias *.dev.* *.dev 
  UseCanonicalName Off
</Virtualhost>
```


Restart apache & reload http://home.dev/test.php & make sure eveything is green :)
`sudo apachectl restart`

Enjoy the boonbøx & start setting up projects :)

—
Thank you [@cmall](https://twitter.com/cmall) for providing [inspiration](http://mallinson.ca/post/osx-web-development) and the basics to this project!
