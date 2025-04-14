#!/bin/bash

# Define file paths
comm_config_dir="configs/etc/irrigator"
comm_config_file="$comm_config_dir/comm_config_test.json"

sm_config_dir="configs/var/lib/irrigator"
sm_config_file="$sm_config_dir/sm_config_test.json"

# Create directories if they don't exist
mkdir -p "$comm_config_dir"
mkdir -p "$sm_config_dir"

--------- Comm Config Inputs ---------
echo "Enter values for comm_config.json"

read -p "Enter wateringReadDelay (in seconds): " wateringReadDelay
read -p "Enter boundsReadDelay (in seconds): " boundsReadDelay

read -p "Enter ThingSpeak sensor channel ID: " sensorChannelID
read -p "Enter ThingSpeak read API key for sensor channel: " sensorReadAPIKey
read -p "Enter ThingSpeak write API key for sensor channel: " sensorWriteAPIKey

read -p "Enter ThingSpeak state channel ID: " stateChannelID
read -p "Enter ThingSpeak read API key for state channel: " stateReadAPIKey
read -p "Enter ThingSpeak write API key for state channel: " stateWriteAPIKey

# Write comm_config.json
cat <<EOF > "$comm_config_file"
{
  "serverComm": {
    "wateringReadDelay": $wateringReadDelay,
    "boundsReadDelay": $boundsReadDelay
  },
  "requestSensor": {
    "channelID": $sensorChannelID,
    "readAPIKey": "$sensorReadAPIKey",
    "writeAPIKey": "$sensorWriteAPIKey"
  },
  "requestState": {
    "channelID": $stateChannelID,
    "readAPIKey": "$stateReadAPIKey",
    "writeAPIKey": "$stateWriteAPIKey"
  }
}
EOF

echo "Created: $comm_config_file"

--------- SM Config Inputs ---------
echo ""
echo "Enter values for sm_config.json"

read -p "Enter upper bound (e.g. 0.75): " upperBound
read -p "Enter lower bound (e.g. 0.2): " lowerBound

# Write sm_config.json 
cat <<EOF > "$sm_config_file"
{
  "upperBound": "$upperBound",
  "lowerBound": "$lowerBound"
}
EOF

echo "Created: $sm_config_file"