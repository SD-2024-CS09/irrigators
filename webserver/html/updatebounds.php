<?php
$json_string = json_encode($_POST);
$sucess = 1;

$upper_bound = $_POST["upperBound"];
$lower_bound = $_POST["lowerBound"];

$error_style = "position: absolute; top: 0; left: 0; width: 98%; margin: 0px; padding: 3px; background-color: #CA2720; color: #FFFFFF;";

if (!is_numeric($upper_bound)) {
  echo sprintf('<div align="center" style="%s">Invalid entry "%s". State machine bounds must be a number in the range [0, 1].</div>', $error_style,  $upper_bound);
} else if (!is_numeric($lower_bound)) {
  echo sprintf('<div align="center" style="%s">Invalid entry "%s". State machine bounds must be a number in the range [0, 1].</div>', $error_style, $lower_bound);
} else if ($upper_bound <= $lower_bound) {
	echo sprintf('<div align="center" style="%s">Invalid range [%s, %s]. State Machine maximum must be higher than state machine minumum.</div>', $error_style, $lower_bound, $upper_bound);
} else if ($upper_bound > 1 || $lower_bound < 0) {
	echo sprintf('<div align="center" style="%s">Invalid range [%s, %s] for state machine. Bounds must fit in the range [0, 1].</div>', $error_style, $lower_bound, $upper_bound);
} else {
  try {
    $file_handle = fopen('/var/lib/irrigator/sm_config.json', 'w');
    fwrite($file_handle, $json_string);
    fclose($file_handle);
    $sucess = 0;
	echo sprintf('Sucessfully updated state machine bounds to [%s, %s]', $lower_bound, $upper_bound);
  }
  catch(Exception $e) {
    echo $e;
  }
}
?> 
