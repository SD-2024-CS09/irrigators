<?php
$json_string = json_encode($_POST);
$sucess = 1;

if(($_POST["status"] == 0 || $_POST["status"] == 1) && count($_POST) == 1) {
  try {
    $file_handle = fopen('/var/lib/irrigator/watering.json', 'w');
    fwrite($file_handle, $json_string);
    fclose($file_handle);
    $sucess = 0;
  }
  
  catch(Exception $e) {
    $sucess = $e;
  }
}

echo $sucess;
?> 
