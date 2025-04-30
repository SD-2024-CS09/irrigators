#! /bin/bash

CONFIG_PATH="/etc/irrigator/path_config.json"
MATLAB_PATH=$(jq -r '.matlabPath' $CONFIG_PATH)
IRRIGATOR_PATH=$(jq -r '.irrigatorPath' $CONFIG_PATH)

if [ ! -f "${IRRIGATOR_PATH}/matlab.log" ]; then
  touch "${IRRIGATOR_PATH}/matlab.log"
fi

$MATLAB_PATH -nodisplay -nosplash -nodesktop -r "run('${IRRIGATOR_PATH}/src/Irrigator.m'); exit();" > "${IRRIGATOR_PATH}/matlab.log" 2>&1