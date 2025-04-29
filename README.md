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

1. Deploy sensors and connect to the Arduino + ESP32 using wiring diagram.
2. Upload the control code and connect to Wi-Fi.
3. Create two ThingSpeak channels one for decision and one for sensor values.
4. Configure src/hw/secrets.h.example for connecting to Wifi and ThingSpeak.
5. run configs/create_configs.sh and enter API keys and initial state
6. WEBSERVER STUFF

## Team Responsibilities

- **ThingSpeak Integration:** Mads, Caleb, Matt  
- **MATLAB State Machine:** Caleb  
- **Dashboard (Nginx):** Mads  
- **Hardware (Arduino + ESP32):** Arvand, Matt  



to run the state machine unit tests, execute the following command at ```test/sm```:

```shell
matlab -batch "run('run_sm_tests.m');"
```





