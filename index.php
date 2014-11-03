<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<?php
			$config = json_decode(file_get_contents('config.json'), true);
		?>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><?php echo $config['name']; ?></title>
		<meta name="viewport" content="width=device-width">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
		<link rel="stylesheet" href="http://css-spinners.com/css/spinner/throbber.css" type="text/css">
		<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
		<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
		<link href='assets/styles.css' rel='stylesheet' type='text/css'>
		<script src="assets/scripts.js"></script>
	</head>
	<body>
		<nav class="navbar navbar-default" role="navigation">
			<div class="container-fluid">
				<div class="navbar-header">
					<a id="brand" class="navbar-brand" href="#">
						<?php
							if (file_exists('assets/additional/' . $config['name'] . '-logo-wide.png')) {
								echo '<img class="brand-logo" alt="' . $config['name'] . '" src="assets/additional/' . $config['name'] . '-logo-wide.png">';
							} else {
								echo $config['name'];
							}
						?>
					</a>
				</div>
				<div class="container">					
					<?php
						foreach (  $config['devtools'] as $tool ) {
							printf( '<a href="%1$s" class="btn btn-default navbar-btn ext-link">%2$s</a>', $tool['url'], $tool['name'] );
						}
						if (isset( $config['howtolink'])) {
					?>
						<a href="<?php echo $config['howtolink']; ?>" class="how-to pull-right btn btn-link navbar-btn ext-link">How to?</a>
					<?php
						}
					?>	
				</div>				
			</div>
		</nav>
		<div class="container">
			<div id="successAlertWrapper"></div>
		</div>
		<div id="main-content-wrapper" class="container">			
			<div id="main-content">
				<h1><?php echo $config['title']; ?></h1><br>
				<ul class="list-group list-unstyled row">
					<?php
						function url_exists($url) {
					    $file_headers = @get_headers($url);
							if ($file_headers[0] == 'HTTP/1.1 404 Not Found') {
							   $exists = false;
							} else {
							   $exists = true;
							}
							return $exists;
						}

						$is_online = url_exists('http:google.com');

						foreach( glob( $config['dirname'] . '*' ) as $file )  {
							$project = basename($file);
							if ( in_array( $project, $config['hiddensites'] ) ) continue;
							// Display a link to the site
	            $displayname = $project;
	            if ( array_key_exists( $project, $config['siteoptions'] ) ) {
	            	if ( is_array( $config['siteoptions'][$project] ) ) {
	            		$displayname = array_key_exists( 'displayname', $config['siteoptions'][$project] ) ? $config['siteoptions'][$project]['displayname'] : $project;
	            	}
	            	else {
	            		$displayname = $config['siteoptions'][$project];
	            	}
	            }
							echo '<li class="col-sm-6 col-md-4 col-lg-3 site-item ' . $project . '">';
							$siteroot = sprintf( 'http://%1$s.%2$s', $project, $config['tld'] );

		          // Display an icon for the site
							$icon_output = NULL;

							foreach( $config['icons'] as $icon ) {
								foreach( $config['rootfolder'] as $rootfolder ) {
									$icon_path = count($rootfolder) >= 2 ? $rootfolder[0] . '/' . $rootfolder[1] : $rootfolder[0];
									if (file_exists( $file . '/' . $icon_path . '/' . $icon )) {
										$icon_output = sprintf( 'style="background-image:url(%1$s/%2$s);"', count($rootfolder) > 1 ? $siteroot . '/' . $rootfolder[1] : $siteroot, $icon );
										break;
	            		}
								}
								if (isset($icon_output)) {
									break;
								}
							}
		            
	            printf( '<a class="list-group-item site-link ' . $displayname . '" href="%1$s" ' . $icon_output . '>%2$s', $siteroot, $displayname );

	            // Display an icon with a link to the admin area
	            $adminurl = '';

	            foreach( $config['rootfolder'] as $rootfolder ) {
	            	foreach ($config['adminpath'] as $adminpath) {
	            		if ( is_dir( $file . '/' . $rootfolder[0] . '/' . $adminpath[0] ) ) {
			            	$adminurl = $siteroot . '/' . $adminpath[1];
			            }
	            	}	
	            }

							// If the user has defined an adminurl for the project we'll use that instead
	            if (isset($config['siteoptions'][$project]) && is_array( $config['siteoptions'][$project] ) && array_key_exists( 'adminurl', $config['siteoptions'][$project] ) ) {
	            	$adminurl = $config['siteoptions'][$project]['adminurl'];
	            }
		        
		          echo '</a>';								
		          echo '<div class="dropdown admin-link">';
							echo '  <button class="btn btn-default dropdown-toggle badge glyphicon glyphicon-cog" type="button" data-toggle="dropdown"> </button>';
							echo '  <ul class="dropdown-menu dropdown-menu-right" role="menu" >';
							if ( ! empty( $adminurl ) ) {
								echo '    <li role="presentation"><a role="menuitem" tabindex="-1" href="' . $adminurl . '"><span class="dropdown-icon glyphicon glyphicon-user"></span>Back-end login</a></li>';
							}
							echo '    <li role="presentation"><a role="menuitem" tabindex="-1" href="http://' . $project . '.' . $config['tld'] . '.' . gethostbyname(trim(`hostname`)) . '.xip.io"><span class="dropdown-icon glyphicon glyphicon-flash"></span>xip.io link</a></li>';
							$exists_on_stage = url_exists('http://' . $project . '.stage.bcon.io');
							if ($is_online && $exists_on_stage) {
								echo '    <li role="presentation"><a role="menuitem" tabindex="-1" href="http://' . $project . '.stage.bcon.io"><span class="dropdown-icon glyphicon glyphicon-share"></span>Staging link</a></li>';
							}
							if ($config['showactions']) {
								echo '		<li role="presentation" class="divider"></li>';								
								if ($is_online && !$exists_on_stage) {
									echo '    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" class="actionBtn pushBtn" data-project=' . $project . '><span class="dropdown-icon glyphicon glyphicon-cloud-upload"></span>Create on staging</a></li>';
								}
								if (file_exists($file . '/Capfile') && file_exists($file . '/Gemfile') && $is_online) {
									echo '    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" class="actionBtn pullBtn" data-project=' . $project . '><span class="dropdown-icon glyphicon glyphicon-cloud-download"></span>Pull uploads & db</a></li>';
								}
								echo '    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" class="actionBtn removeBtn" data-project=' . $project . '><span class="dropdown-icon glyphicon glyphicon-remove"></span>Remove ' . $project . '</a></li>';
							}
							echo '  </ul>';
							echo '</div>';
		          echo '</li>';
						}
			   		if ($config['showaddlink']) {
			   	?>
			   			<li class="col-sm-6 col-md-4 col-lg-3 site-item"><button class="list-group-item site-link add-new" data-toggle="modal" data-target="#addModal"><span class="glyphicon glyphicon-plus"></span> Add new</button></li>
		   		<?php } ?>
		   	</ul>

		   	<div class="col-12-md footer">
		   		<small>Proudly presented by <a href="//pixels.fi">booncon PIXELS</a></small>		   		
		   	</div>
			</div>
		</div>
		<!-- Modal -->
		<div class="modal fade" data-backdrop="static" id="addModal" tabindex="-1" role="dialog" aria-labelledby="addModalLabel" aria-hidden="true">
		  <div class="modal-dialog">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h4 class="modal-title" id="myModalLabel">Add a new project</h4>
		      </div>
		      <div class="modal-body">
						<ul class="nav nav-tabs" role="tablist">
						  <li role="presentation" class="active"><a href="#existingTab" role="tab" data-toggle="tab">Existing</a></li>
						  <li role="presentation"><a href="#newTab" role="tab" data-toggle="tab">New</a></li>
						</ul>
						<div class="tab-content">
						  <br>
						  <div id="addProjectFormAlertWrap"></div>
						  <div role="tabpanel" class="tab-pane active" id="existingTab">
						  	<form id="addProjectForm" role="form">
								  <div class="input-group">
								    <input type="github" class="form-control" id="githubInput" placeholder="SSH clone URL to the existing repository...">
							      <span class="input-group-btn">
							        <button type="submit" class="btn btn-primary" id="addProject" data-loading-text="<i class='throbber'></i>">Clone project</button>
							      </span>
								  </div>
								</form>
						  </div>
						  <div role="tabpanel" class="tab-pane" id="newTab">
						  	<form id="createProjectForm" role="form">
								  <div class="input-group">
								    <input type="github" class="form-control" id="projectName" placeholder="Name of the new project...">
							      <span class="input-group-btn">
							        <button type="submit" class="btn btn-primary" id="createProject" data-loading-text="<i class='throbber'></i>">Create project</button>
							      </span>
								  </div>
								</form>
						  </div>
							<br>
						  <span id="db-info" class="help-block"><strong>Remember:</strong> If a database with the same project name exists, it will be overwritten.</span>
						  <div id="giphy-wrap" class="giphy-wrap hide">
				   			<img id="giphy" class="img-responsive giphy">
				   		</div>
						</div>		        
		      </div>
		      <div class="modal-footer">
		        <button id="closeModalBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>		        
		      </div>
		    </div>
		  </div>
		</div>
	</body>
</html>