<!DOCTYPE html>
<?php $config = json_decode(file_get_contents('config.json'), true); ?>
<html>
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>System test</title>
    <meta name="viewport" content="width=device-width">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/styles.css">
  </head>
  <body>
    <div class="container-fluid">
      <div class="container test-container">
        <h1><?php echo $config['name']; ?> system test</h1><br>
    		<?php          
          exec('sudo -u ' . $config['username'] . ' ' . getcwd() . '/scripts/test.sh ', $messages, $returnCode);
          echo implode('<br>', $messages);
        ?>
        <br>
        <br>
      </div>
    </div>
	</body>	
</html>