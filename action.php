<?php
  $config = json_decode(file_get_contents('config.json'), true);
  $returnCode = 1;
  if (isset($_GET["add"])) {
    exec('sudo -u ' . $config['username'] . ' ' . getcwd() . '/scripts/add.sh ' . $_GET["add"], $messages, $returnCode);
    echo implode('<br>', $messages);
    if ($returnCode !== 0) {
      header("HTTP/1.0 406 Not Acceptable");
      exit();
    }
  }
  if (isset($_GET["create"])) {
    exec('sudo -u ' . $config['username'] . ' ' . getcwd() . '/scripts/create.sh ' . $_GET["create"], $messages, $returnCode);
    echo implode('<br>', $messages);
    if ($returnCode !== 0) {
      header("HTTP/1.0 406 Not Acceptable");
      exit();
    }
  }
  if (isset($_GET["pull"])) {
    $returnCode = 0;
    exec('sudo -u ' . $config['username'] . ' ' . getcwd() . '/scripts/pull.sh ' . $_GET["pull"], $messages, $returnCode);
    echo implode('<br>', $messages);
  }
  if (isset($_GET["npm"])) {
    $returnCode = 0;
    exec('sudo -u ' . $config['username'] . ' ' . getcwd() . '/scripts/npm.sh ' . $_GET["npm"], $messages, $returnCode);
    echo implode('<br>', $messages);
  }
  if (isset($_GET["remove"])) {
    $returnCode = 0;
    exec('sudo -u ' . $config['username'] . ' ' . getcwd() . '/scripts/remove.sh ' . $_GET["remove"], $messages, $returnCode);
    echo implode('<br>', $messages);
  }
  if ($returnCode !== 0) {
    header("HTTP/1.0 406 Not Acceptable");
    exit();
  }
?>