<?php

/**
*  
*  This is just a simple config file to store your web root and a few other items
*  
*  Change "/www/sites/*" to the directory where you keep your sites. 
*  Add multiple directories like this:
*  
*  $dir = array("/www/sites1/*","/www/sites2/*");
*  
*/

$name = 'boonbøx';

$header = 'Your local development projects:';

$howtolink = 'https://www.dropbox.com/sh/r2ylo6d14hqf33k/AAATcDfRsoq0AfuCqUOl4EMNa?dl=0';

/** directory name(s) */
$dir = array("/www/sites/*");
          
/** Your local top level domain */
$tld = 'dev';

$rootfolder = 'web';

$username = 'sftsk';


/*
*
*  Icon file names you would like to display next to the link to each site. 
*  In order of the priority they should be used.
*
*/
$icons = array( 'apple-touch-icon.png', 'favicon.ico' );

/*
*
*  Development tools you want displayed in the top navigation bar. Each item should be
*  an array containing keys 'name' and 'url'. An example is included (commented out) below.
*
*/
$devtools = array(
  array( 'name' => 'Stage', 'url' => 'http://home.stage.bcon.io/' ),
  array( 'name' => 'Github', 'url' => 'https://github.com/booncon' ),
  array( 'name' => 'Trello', 'url' => 'https://trello.com' ),
  array( 'name' => 'booncloud', 'url' => 'https://cloud.bcon.io/' ),
  array( 'name' => 'Digital Ocean', 'url' => 'https://cloud.digitalocean.com/' ),
  array( 'name' => 'Hover', 'url' => 'https://www.hover.com/domains/' ),
  array( 'name' => 'PHP Info', 'url' => 'phpinfo.php' ),
  );

$showaddlink = true;
$showactions = true;

/*
*
*  Options for sites being displayed. These are completely optional, if you don't set
*  anything there are default options which will take over.
*
*  If you only want to specify a display name for a site you can use the format:
*
*  'sitedir' => 'Display Name',
*
*  Otherwise, if you want to set additional options you'll use an array for the options.
*
*  'sitedir' => array( 'displayname' => 'Display Name', 'adminurl' => 'http://example.sites.dev/admin' ),
*
*/      
$siteoptions = array(
//  'dirname' => 'Display Name',
  // 'gapps' => array( 'displayname' => 'Gapps', 'adminurl' => 'http://gapps.dev/admin' ),

  );

/*
*
*  Directory names of sites you want to hide from the page. If you're using multiple directories
*  in $dir be aware that any directory names in the array below that show up in any of 
*  your directories will be hidden.
* 
*/
$hiddensites = array( 'home', '_archive', 'index.html' );