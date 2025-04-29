#! /bin/bash

MATLAB_PATH="example/path/MATLAB/R2024b/bin/matlab"
IRRIGATORS_PATH="example/path/irrigators"

if [ ! -f "${IRRIGATORS_PATH}/matlab.log" ]; then
  touch "${IRRIGATORS_PATH}/matlab.log"
fi

$MATLAB_PATH -nodisplay -nosplash -nodesktop -r "run('${IRRIGATORS_PATH}/src/Irrigator.m'); exit();" > "${IRRIGATORS_PATH}/matlab.log" 2>&1
