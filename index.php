<!DOCTYPE html>
<?php require('config.php'); ?>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><?php echo $name; ?></title>
		<meta name="viewport" content="width=device-width">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
		<link rel="stylesheet" href="http://css-spinners.com/css/spinner/throbber.css" type="text/css">
		<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
		<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
		<style>
			/* originally authored by Nick Pettit - https://github.com/nickpettit/glide */
			@-webkit-keyframes tada {
			  0% {
			    -webkit-transform: scale3d(1, 1, 1);
			            transform: scale3d(1, 1, 1);
			  }

			  10%, 20% {
			    -webkit-transform: scale3d(.9, .9, .9) rotate3d(0, 0, 1, -3deg);
			            transform: scale3d(.9, .9, .9) rotate3d(0, 0, 1, -3deg);
			  }

			  30%, 50%, 70%, 90% {
			    -webkit-transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, 3deg);
			            transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, 3deg);
			  }

			  40%, 60%, 80% {
			    -webkit-transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, -3deg);
			            transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, -3deg);
			  }

			  100% {
			    -webkit-transform: scale3d(1, 1, 1);
			            transform: scale3d(1, 1, 1);
			  }
			}

			@keyframes tada {
			  0% {
			    -webkit-transform: scale3d(1, 1, 1);
			            transform: scale3d(1, 1, 1);
			  }

			  10%, 20% {
			    -webkit-transform: scale3d(.9, .9, .9) rotate3d(0, 0, 1, -3deg);
			            transform: scale3d(.9, .9, .9) rotate3d(0, 0, 1, -3deg);
			  }

			  30%, 50%, 70%, 90% {
			    -webkit-transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, 3deg);
			            transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, 3deg);
			  }

			  40%, 60%, 80% {
			    -webkit-transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, -3deg);
			            transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, -3deg);
			  }

			  100% {
			    -webkit-transform: scale3d(1, 1, 1);
			            transform: scale3d(1, 1, 1);
			  }
			}
			/* Thanks a lot http://css-spinners.com/css/spinner/throbber.css */
			@-webkit-keyframes throbber {
			  0% {
			    background: #dde2e7;
			  }

			  10% {
			    background: #6b9dc8;
			  }

			  40% {
			    background: #dde2e7;
			  }
			}
			@keyframes throbber {
			  0% {
			    background: #dde2e7;
			  }

			  10% {
			    background: #6b9dc8;
			  }

			  40% {
			    background: #dde2e7;
			  }
			}

			/* :not(:required) hides these rules from IE9 and below */
			.throbber:not(:required) {
			  -webkit-animation: throbber 2000ms 300ms infinite ease-out;
			  -moz-animation: throbber 2000ms 300ms infinite ease-out;
			  -ms-animation: throbber 2000ms 300ms infinite ease-out;
			  -o-animation: throbber 2000ms 300ms infinite ease-out;
			  animation: throbber 2000ms 300ms infinite ease-out;
			  background: #dde2e7;
			  display: inline-block;
			  position: relative;
			  text-indent: -9999px;
			  width: 0.6em;
			  height: 0.8em;
			  margin: 0 1.2em;
			}
			.throbber:not(:required):before, .throbber:not(:required):after {
			  background: #dde2e7;
			  content: '\x200B';
			  display: inline-block;
			  width: 0.6em;
			  height: 0.8em;
			  position: absolute;
			  top: 0;
			}
			.throbber:not(:required):before {
			  -webkit-animation: throbber 2000ms 150ms infinite ease-out;
			  -moz-animation: throbber 2000ms 150ms infinite ease-out;
			  -ms-animation: throbber 2000ms 150ms infinite ease-out;
			  -o-animation: throbber 2000ms 150ms infinite ease-out;
			  animation: throbber 2000ms 150ms infinite ease-out;
			  left: -1.2em;
			}
			.throbber:not(:required):after {
			  -webkit-animation: throbber 2000ms 450ms infinite ease-out;
			  -moz-animation: throbber 2000ms 450ms infinite ease-out;
			  -ms-animation: throbber 2000ms 450ms infinite ease-out;
			  -o-animation: throbber 2000ms 450ms infinite ease-out;
			  animation: throbber 2000ms 450ms infinite ease-out;
			  right: -1.2em;
			}
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
				background-position: 4px 50%;
				position: relative;
				border-bottom-left-radius: 4px;
				border-bottom-right-radius: 4px;
			}
			.site-item.loading .site-link {
				text-align: center;
				padding-left: 0;
			}
			.site-link.new {
				-webkit-animation: tada 2000ms 300ms ease-out;
				animation: tada 2000ms 300ms ease-out;
			}
			.admin-link {
				position: absolute;
				right: 10%;
				top: 25%;
			}
			.dropdown-icon {
				padding-right: 8px;
				position: relative;
				top: 2px;
			}
			.add-new.list-group-item {
				border: none;
				background: none;
				padding-left: 0;
			}
			.add-new.list-group-item:hover {
				background: none;
				color: #e24b70;
			}
			.add-new.list-group-item:focus {
				outline: none;
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
			var factinator;
			var errors = ['Please enter a valid github repository.', 'Please enter a valid project name.'];

			function showNumber(str) {
        $('#number-fact').html(str + '<br>');
    	}

			var showAlert = function (type, message) {
				var html = '<div id="addProjectAlert" class="alert alert-' + type + ' alert-dismissible" role="alert">';
				  html += '<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>';
				  html += '<span class="message">' + message + '</span></div>';
				return html;
			};

			var showFacts = function () {
				$('#db-info').hide();
				$('#githubInput, #projectName').prop('readonly', true);
				$('#closeModalBtn').prop('disabled', true);
				factinator = window.setInterval(function () {
					(function() {
			        var scriptTag = document.createElement('script');
			        scriptTag.async = true;
			        scriptTag.src = "http://numbersapi.com/random?callback=showNumber";
			        document.body.appendChild(scriptTag);
			    })();
				}, 6000);
			};

			var stopFacts = function () {
				$('#githubInput, #projectName').prop('readonly', false);
				$('#closeModalBtn').prop('disabled', false);
				$('#db-info').show();
				clearInterval(factinator);
				$('#number-fact').html('');
			};

			$(document).ready(function () {
				$('.actionBtn').click(function (e) {					
					var projectName = $(this).data('project');
					var displayName = $('.site-link.' + projectName).text();
					if ($(this).hasClass('removeBtn')) {
						var message = "Attention: This will remove all your local project files and wipe the database and user. Do you really want to delete this project? ";
						var x = confirm(message);
						if (x == true) {
							$('.site-link.' + projectName).html('<i class="throbber"></i>').parent().addClass('loading').children().children('.dropdown-toggle').addClass('disabled');
							$.ajax({
							  type: "GET",
							  url: "action.php",
							  data: { remove: projectName }
							}).success(function (response) {
								console.log(response);					  	
								$('#successAlertWrapper').html(showAlert('success', '<strong>Success!</strong> You removed the project "' + projectName + '".'));
								$('.site-link.' + projectName).text(displayName).parent().removeClass('loading').children().children('.dropdown-toggle').removeClass('disabled');
								window.setTimeout(function () {
									$('#successAlertWrapper').html('');
								}, 10000);
						    $('#main-content-wrapper').load('index.php #main-content');				    
						  }).error(function (response) {
						  	console.log(response);
						  	$('#successAlertWrapper').html(showAlert('danger', '<strong>Error!</strong> ' + response.responseText));
						  });
						}
					} else if ($(this).hasClass('pullBtn')) {
						var message = "Attention: This will overwrite your existing database. Are you sure there is nothing you need from it anymore?";
						var x = confirm(message);
						if (x == true) {
							$('.site-link.' + projectName).html('<i class="throbber"></i>').parent().addClass('loading').children().children('.dropdown-toggle').addClass('disabled');
							$.ajax({
							  type: "GET",
							  url: "action.php",
							  data: { pull: projectName }
							}).success(function (response) {
								console.log(response);					  	
								$('#successAlertWrapper').html(showAlert('success', '<strong>Success!</strong> Your project "' + projectName + '" is now in sync with staging.'));
								$('.site-link.' + projectName).text(displayName).parent().removeClass('loading').children().children('.dropdown-toggle').removeClass('disabled');
								window.setTimeout(function () {
									$('#successAlertWrapper').html('');
								}, 10000);				    
						  }).error(function (response) {
						  	console.log(response);
						  	$('#successAlertWrapper').html(showAlert('danger', '<strong>Error!</strong> ' + response.responseText));
						  });
						}
					}
					e.preventDefault();
				});
				$('.site-link.add-new, .nav-tabs a').click(function () {
					$('#addProjectFormAlertWrap, #successAlertWrapper').html('');
					$('#githubInput, #projectName').val('');
				});
				$( "#addProjectForm" ).submit(function( event ) {
					$('#addProjectFormAlertWrap').html('');
					var githubURL = $('#githubInput').val();
					if (githubURL !== '' && githubURL.indexOf('/') !== -1) {
						showFacts();
						var projectName = githubURL.split('/');
						projectName = projectName[projectName.length - 1].split('.')[0]
						var $btn = $("#addProject").button('loading');
						$.ajax({
						  type: "GET",
						  url: "action.php",
						  data: { add: $('#githubInput').val(), pull: projectName }
						}).success(function (response) {
							console.log(response);					  	
							$('#successAlertWrapper').html(showAlert('success', '<strong>Success!</strong> You have added the project "' + projectName + '".'));
							$('#addModal').modal('hide');
							window.setTimeout(function () {
								$('#successAlertWrapper').html('');
								$('.site-link').removeClass('new');
							}, 10000);
					  	$btn.button('reset');
					    $('#main-content-wrapper').load('index.php #main-content', function () {
					    	$('.site-link.' + projectName).addClass('new');
					    });							
					    $('#githubInput').val('');
					    stopFacts();					    
					  }).error(function (response) {
					  	console.log(response);
					  	$('#addProjectFormAlertWrap').html(showAlert('danger', '<strong>Error!</strong> ' + response.responseText));
					    $btn.button('reset');
					    stopFacts();
					  });
					} else {
					  $('#addProjectFormAlertWrap').html(showAlert('danger', '<strong>Error!</strong> ' + errors[0]));
					  stopFacts();
					}
				  event.preventDefault();
				});
				$( "#createProjectForm" ).submit(function( event ) {
					$('#addProjectFormAlertWrap').html('');
					showFacts();
					var projectName = $('#projectName').val();
					if ($('#projectName').val() !== '') {
						$('#successAlertWrapper').html(showAlert('success', '<strong>Success!</strong> Create the project ' + projectName + ': composer create ' + projectName + '; roots sass clone as ' + projectName + '; pull styles from git;'));
						$('#addModal').modal('hide');
						window.setTimeout(function () {
							$('#successAlertWrapper').html('');
							$('.site-link').removeClass('new');
						}, 10000);
						$('.site-link.' + projectName).addClass('new');
						$('#projectName').val('');
						stopFacts();
					}	else {
					  $('#addProjectFormAlertWrap').html(showAlert('danger', '<strong>Error!</strong> ' + errors[1]));
					  stopFacts();
					}
				  event.preventDefault();
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
						if (isset($howtolink)) {
					?>
						<a href="<?php echo $howtolink; ?>" class="how-to pull-right btn btn-link navbar-btn ext-link">How to?</a>
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
				<h1><?php echo $header; ?></h1><br>
				<ul class="list-group list-unstyled row">
					<?php
						foreach ( $dir as $d ) {
							$dirsplit = explode('/', $d);
							$dirname = $dirsplit[count($dirsplit)-2];
							foreach( glob( $d ) as $file )  {
								$project = basename($file);
								if ( in_array( $project, $hiddensites ) ) continue;
								// Display a link to the site
		            $displayname = $project;
		            if ( array_key_exists( $project, $siteoptions ) ) {
		            	if ( is_array( $siteoptions[$project] ) ) {
		            		$displayname = array_key_exists( 'displayname', $siteoptions[$project] ) ? $siteoptions[$project]['displayname'] : $project;
		            	}
		            	else {
		            		$displayname = $siteoptions[$project];
		            	}
		            }
								echo '<li class="col-sm-6 col-md-4 col-lg-3 site-item">';
								$siteroot = sprintf( 'http://%1$s.%2$s', $project, $tld );

			          // Display an icon for the site
								$icon_output = NULL;
								foreach( $icons as $icon ) {
									if ( file_exists( $file . '/' . $rootfolder . '/' . $icon ) || file_exists( $file . '/docroot/' . $icon ) ) {
										$icon_output = sprintf( 'style="background-image:url(%1$s/%2$s);"', $siteroot, $icon );
										break;
		            	}
		            }
			            
		            printf( '<a class="list-group-item site-link ' . $displayname . '" href="%1$s" ' . $icon_output . '>%2$s', $siteroot, $displayname );

								// Display an icon with a link to the admin area
		            $adminurl = '';
								// We'll start by checking if the site looks like it's a WordPress site
		            if ( is_dir( $file . '/' . $rootfolder . '/wp/wp-admin' ) ) {
		            	$adminurl = sprintf( '%1$s/admin', $siteroot );
		            } else if ( is_dir( $file . '/' . $rootfolder . '/sites/all' ) ) {
		            	$adminurl = sprintf( '%1$s/user', $siteroot );
		            } else if ( is_dir( $file . '/docroot/sites/all' ) ) {
		            	$adminurl = sprintf( '%1$s/user', $siteroot );
		            } else if ( is_dir( $file . '/' . $rootfolder . '/manager' ) ) {
		            	$adminurl = sprintf( '%1$s/manager', $siteroot );
		            }

								// If the user has defined an adminurl for the project we'll use that instead
		            if (isset($siteoptions[$project]) &&  is_array( $siteoptions[$project] ) && array_key_exists( 'adminurl', $siteoptions[$project] ) ) {
		            	$adminurl = $siteoptions[$project]['adminurl'];
		            }
			        
			          echo '</a>';								
			          echo '<div class="dropdown admin-link">';
								echo '  <button class="btn btn-default dropdown-toggle badge glyphicon glyphicon-cog" type="button" data-toggle="dropdown"> </button>';
								echo '  <ul class="dropdown-menu dropdown-menu-right" role="menu" >';
								if ( ! empty( $adminurl ) ) {
									echo '    <li role="presentation"><a role="menuitem" tabindex="-1" href="' . $adminurl . '"><span class="dropdown-icon glyphicon glyphicon-user"></span>Back-end login</a></li>';
								}
								echo '    <li role="presentation"><a role="menuitem" tabindex="-1" href="http://' . $project . '.' . $tld . '.' . gethostbyname(trim(`hostname`)) . '.xip.io"><span class="dropdown-icon glyphicon glyphicon-flash"></span>xip.io link</a></li>';
								if ($showactions) {
									echo '		<li role="presentation" class="divider"></li>';
									echo '    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" class="actionBtn pullBtn" data-project=' . $project . '><span class="dropdown-icon glyphicon glyphicon-cloud-download"></span>Pull uploads & db</a></li>';
									echo '    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" class="actionBtn removeBtn" data-project=' . $project . '><span class="dropdown-icon glyphicon glyphicon-remove"></span>Remove the project</a></li>';
								}
								echo '  </ul>';
								echo '</div>';
			          echo '</li>';
							}
			   		}
			   		if ($showaddlink) {
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
							        <button type="submit" class="btn btn-primary" id="createProject">Create project</button>
							      </span>
								  </div>
								</form>
						  </div>
							<br>
						  <span id="db-info" class="help-block"><strong>Remember:</strong> If a database with the same project name exists, it will be overwritten.</span>
						  <span id="number-fact" class="help-block"></span>
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