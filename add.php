<?php
  require('config.php');
  $returnCode = 1;
  if (isset($_GET["url"])) {
    exec('sudo -u ' . $username . ' ' . getcwd() . '/scripts/add.sh ' . $_GET["url"], $messages, $returnCode);
    foreach ($messages as $key => $message) {
      echo $message . '<br>';
    }
  }
  if ($returnCode !== 0) {
    header("HTTP/1.0 406 Not Acceptable");
    exit();
  }
?>