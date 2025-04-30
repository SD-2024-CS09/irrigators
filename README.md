# Smart Indoor Watering System

Water conservation is a critical challenge in agriculture. Traditional irrigation methods often waste resources and harm plants due to inefficient water distribution. This project leverages IoT sensors and MathWorks tooling to optimize indoor irrigation for leafy-green gardening, ensuring plants receive the right amount of water at the right time with minimal human involvement.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [System Architecture](#system-architecture)
- [Installation](#installation)
- [Instructions](#instructions)
- [Team Responsibilities](#team-responsibilities)

## Overview

This smart watering system monitors soil moisture and other environmental conditions using IoT sensors. The data is sent to ThingSpeak for real-time analysis using MATLAB. A MATLAB-based state machine determines whether to initiate watering. The goal is to minimize water consumption and optimize plant growth in indoor environments like those around Gonzaga.

## Features

- Real-time soil moisture monitoring
- Automated irrigation control
- Integration with ThingSpeak and MATLAB
- ESP32 + Arduino-based hardware system
- Web dashboard hosted via Nginx

## System Architecture

- **Sensors:** Soil moisture sensor
- **Microcontrollers:** Arduino Uno R3, ESP32
- **Communication:** Wi-Fi data transmission to ThingSpeak
- **Data Analysis:** MATLAB scripts and state machine
- **Interface:** Nginx-hosted dashboard for system visualization

## Installation


### Software Requirements

- MATLAB (with ThingSpeak support)
- Arduino IDE
- ESP32 board drivers
- Nginx (for dashboard hosting)

### Hardware Requirements

- Arduino Uno R3
- ESP32 Wi-Fi module
- Soil moisture sensors
- Relay + water pump system

## Instructions

1. Deploy sensors and connect to the Arduino + ESP32 using setup/wiring_diagram.
2. Configure src/hw/secrets.h.example for connecting to Wifi and ThingSpeak and remove .example from file name.
3. Upload src/hw/arduino_program.ino to the Arduino.
4. Upload src/hw/esp32_driver.cpp to the ESP32.
5. Create a thingSpeak account [here](https://thingspeak.mathworks.com/login?skipSSOCheck=true).
6. Create two ThingSpeak channels one for decision and one for sensor values and a field in each channel instructions [here](https://www.mathworks.com/help/thingspeak/collect-data-in-a-new-channel.html).
7. run configs/create_configs.sh and enter API keys and initial state.
8. WEBSERVER STUFF

## Team Responsibilities

- **ThingSpeak Integration:** Mads, Caleb, Matt  
- **MATLAB State Machine:** Caleb  
- **Dashboard (Nginx):** Mads  
- **Hardware (Arduino + ESP32):** Arvand, Matt  



to run the state machine unit tests, execute the following command at ```test/sm```:

```shell
matlab -batch "run('run_sm_tests.m');"
```





