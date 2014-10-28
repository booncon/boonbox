<!DOCTYPE html>
<?php require('config.php'); ?>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><?php echo $name; ?></title>
		<meta name="viewport" content="width=device-width">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
		<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
		<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
		<style>
			body {
				font-family: 'Open Sans', sans-serif;
			}
			.ext-link {
				margin-right: 12px;
			}
			.how-to {
				display: inline-block;
				float: right;
			}
			.site-item {
				margin-bottom: 12px;
			}
			.site-link {
				background-image: url(favicon.png);
				background-size: 32px;
				background-repeat: no-repeat;
				padding-left: 54px;
				position: relative;
				background-position: 4px 50%;
			}
			.admin-link {
				transition: all 0.1s;
			}
			.admin-link:hover {
				background-color: #e24b70;
				transition: all 0.3s;
			}
			.footer {
				text-align: center;
				margin-bottom: 20px;
			}
			@media (min-width: 768px) {
				.footer {
					position: absolute;
					bottom: 10px;
					width: 100%;
					left: 0;
				}
			}
			a {
				color: #3b454f;
			}
			a:hover {
				color: #3b454f;
			}
		</style>
		<script>
			$(document).ready(function () {
				$('.admin-link').click(function (e) {
					if (e.cmdKey || e.metaKey) {
						window.open($(this).data('link'));
					} else {
						window.location = $(this).data('link');
					}
					e.preventDefault();
				});
			});
		</script>
	</head>
	<body>
		<nav class="navbar navbar-default" role="navigation">
			<div class="container-fluid">
				<div class="navbar-header">
					<a class="navbar-brand" href="#"><?php echo $name; ?></a>
				</div>
				<div class="container">					
					<?php
						foreach ( $devtools as $tool ) {
							printf( '<a href="%1$s" class="btn btn-default navbar-btn ext-link">%2$s</a>', $tool['url'], $tool['name'] );
						}
					?>
					<a href="<?php echo $howtolink; ?>" class="how-to pull-right btn btn-link navbar-btn ext-link">How to?</a>
				</div>				
			</div>
		</nav>
		<div class="container">
			<h1><?php echo $header; ?></h1><br>
			<ul class="list-group list-unstyled row">
				<?php
					foreach ( $dir as $d ) {
						$dirsplit = explode('/', $d);
						$dirname = $dirsplit[count($dirsplit)-2];

						foreach( glob( $d ) as $file )  {

							$project = basename($file);

							if ( in_array( $project, $hiddensites ) ) continue;

							echo '<li class="col-sm-6 col-md-4 col-lg-3 site-item">';

							$siteroot = sprintf( 'http://%1$s.%2$s', $project, $tld );

		            // Display an icon for the site
							$icon_output = NULL;
							foreach( $icons as $icon ) {
								if ( file_exists( $file . '/' . $rootfolder . '/' . $icon ) || file_exists( $file . '/docroot/' . $icon ) ) {
									$icon_output = sprintf( 'style="background-image:url(%1$s/%2$s);"', $siteroot, $icon );
									break;
		            	} // if ( file_exists( $file . '/' . $icon ) )

		            } // foreach( $icons as $icon )
		            // echo $icon_output;

		            // Display a link to the site
		            $displayname = $project;
		            if ( array_key_exists( $project, $siteoptions ) ) {
		            	if ( is_array( $siteoptions[$project] ) )
		            		$displayname = array_key_exists( 'displayname', $siteoptions[$project] ) ? $siteoptions[$project]['displayname'] : $project;
		            	else
		            		$displayname = $siteoptions[$project];
		            }
		            printf( '<a class="list-group-item site-link" href="%1$s" ' . $icon_output . '>%2$s', $siteroot, $displayname );


								// Display an icon with a link to the admin area
		            $adminurl = '';
								// We'll start by checking if the site looks like it's a WordPress site
		            if ( is_dir( $file . '/' . $rootfolder . '/wp/wp-admin' ) )
		            	$adminurl = sprintf( '%1$s/admin', $siteroot );
		            else if ( is_dir( $file . '/' . $rootfolder . '/sites/all' ) )
		            	$adminurl = sprintf( '%1$s/user', $siteroot );
		            else if ( is_dir( $file . '/docroot/sites/all' ) )
		            	$adminurl = sprintf( '%1$s/user', $siteroot );
		            else if ( is_dir( $file . '/web/manager' ) )
		            	$adminurl = sprintf( '%1$s/manager', $siteroot );

								// If the user has defined an adminurl for the project we'll use that instead
		            if (isset($siteoptions[$project]) &&  is_array( $siteoptions[$project] ) && array_key_exists( 'adminurl', $siteoptions[$project] ) )
		            	$adminurl = $siteoptions[$project]['adminurl'];

		            // If there's an admin url then we'll show it - the icon will depend on whether it looks like WP or not
		            if ( ! empty( $adminurl ) )
		            	printf( '<span class="admin-link badge glyphicon glyphicon-cog" data-link="%1$s"> </a>', $adminurl );
		            
		          echo '</a></li>';
						} // foreach( glob( $d ) as $file )
		   		} // foreach ( $dir as $d )
		   	?>
	   	</ul>
	   	<div class="col-12-md footer">
	   		<small>Proudly presented by <a href="//booncon.com">booncon</a></small>
	   	</div>
		</div>
	</body>
</html>