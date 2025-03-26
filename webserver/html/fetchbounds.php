<?php
 try {
    echo file_get_contents('/var/lib/irrigator/sm_config.json', 'w');
  }
  catch(Exception $e) {
    echo 0;
  }
?> 
