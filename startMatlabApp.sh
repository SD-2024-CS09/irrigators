#! /bin/bash

MATLAB_PATH = "example/path/MATLAB/R2024b/bin/matlab"
IRRIGATORS_PATH = "example/path/irrigators"

if [ ! -f "./matlab.log" ]; then
  touch "./matlab.log"
fi

$MATLAB_PATH -nodisplay -nosplash -nodesktop -r "run('${IRRIGATORS_PATH}/src/WebServerComm.m'); exit();"
