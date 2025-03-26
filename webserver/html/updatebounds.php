<?php
$json_string = json_encode($_POST);
$sucess = 1;

if($_POST["upperBound"] <= $_POST["lowerBound"]) {
	echo sprintf('<div style="background-color: #EE4B2B;">Invalid range [%s, %s]. State Machine maximum must be lower than state machine minumum.</div>', $_POST["lowerBound"], $_POST["upperBound"]);

} else if ($_POST["upperBound"] > 1 || $_POST["lowerBound"] < 0) {
	echo sprintf('<div style="background-color: #EE4B2B;">Invalid range [%s, %s] for state machine. Bounds must fit in the range [0, 1].</div>', $_POST["lowerBound"], $_POST["upperBound"]);
} else {
  try {
    $file_handle = fopen('/var/lib/irrigator/sm_config.json', 'w');
    fwrite($file_handle, $json_string);
    fclose($file_handle);
    $sucess = 0;
	echo sprintf('Sucessfully updated state machine bounds to [%s, %s]', $_POST["lowerBound"], $_POST["upperBound"]);
  }
  catch(Exception $e) {
    echo $e;
  }
}
?> 