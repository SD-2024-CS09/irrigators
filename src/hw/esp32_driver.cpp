/*
  AUTHOR: Matt Nguyen
  DESCRIPTION: This program connects the ESP32 to Wifi, receives sensor values 
               from our Arduino, writes them to ThingSpeak, and controls the 
               actuation of the water pump.
*/

#include <Arduino.h>
#include <WiFi.h>           
#include "ThingSpeak.h"  
#include "esp_wpa2.h" 
#include "secrets.h"

// Arduino - ESP32 UART
#define TX 17  
#define RX 16 
#define RELAY_PIN 23

// Wifi SSID
const char* ssid = "Gonzaga Community"; 

// Wifi client for ThingSpeak
WiFiClient client;

// Timer variables
unsigned long lastTime = 0;
const unsigned long timerDelay = 16000;  // delay between updates in ms

// Variables for sensor data
float soilMoisture = 0.0; 

void setup() {
  // Initialize serial monitors
  Serial.begin(115200);
  Serial2.begin(9600, SERIAL_8N1, RX, TX);

  // Connect to Wi-Fi
  Serial.begin(115200);
  delay(10);
  Serial.print(F("Connecting to network: "));
  Serial.println(SSID);
  WiFi.disconnect(true); 
  WiFi.begin(ssid, WPA2_AUTH_PEAP, EAP_IDENTITY, EAP_USERNAME, EAP_PASSWORD); 
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(F("."));
  }
  Serial.println("");
  Serial.println(F("WiFi is connected"));

  // Initialize ThingSpeak
  ThingSpeak.begin(client);

  // Initialize GPIO pin as output for water pump actuation
  pinMode(RELAY_PIN, OUTPUT);
}

void loop() {
  // Timer since we can only write to ThingSpeak every 15s
  if (millis() - lastTime > timerDelay) {
    // Read the watering decision
    int wateringDecision = ThingSpeak.readFloatField(DECISION_CHANNEL_NUMBER, 1, READ_API_KEY);

    if (wateringDecision == -1) {
      Serial.println("Error reading data from ThingSpeak.");
    } 
    else {
      Serial.print("Watering Decision: ");
      Serial.println(wateringDecision);
      
      // Act on the watering decision
      if (wateringDecision == 1) {
         digitalWrite(RELAY_PIN, HIGH);
      } 
      else if (wateringDecision == 0) {
         digitalWrite(RELAY_PIN, LOW);
      } 
      else {
        Serial.print("Error: Invalid watering decision value: ");
        Serial.println(wateringDecision);
        // Default to turning off the relay
        digitalWrite(RELAY_PIN, LOW); 
      }
      
      String data = Serial2.readString();
      soilMoisture = data.toFloat();
      Serial.print("Soil Moisture (%): ");
      Serial.println(soilMoisture);

      // Send the updated soil moisture
      int responseCode = ThingSpeak.writeField(VALUE_CHANNEL_NUMBER, 1, soilMoisture, WRITE_API_KEY);
      if (responseCode == 200) {
        Serial.println("Soil moisture data sent successfully.");
      } 
      else {
        Serial.println("Error sending soil moisture data. HTTP error code: " + String(responseCode));
      }
    }

    // Update the timer
    lastTime = millis();
  }
}
