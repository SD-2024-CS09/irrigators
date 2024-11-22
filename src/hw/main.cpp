#include <WiFi.h>           
#include "ThingSpeak.h"    

// Wi-Fi credentials
const char* ssid = "";  
const char* password = ""; 

// ThingSpeak credentials
unsigned long decisionChannelNumber = 2756308;
unsigned long valueChannelNumber = 2667716; 
const char* myWriteAPIKey = "6AO4PYC5RM7D1KJX";
const char* myReadAPIKey = "OHUMTAKIQY4CC2I7";   

// Wi-Fi client for ThingSpeak
WiFiClient client;

// Timer variables
unsigned long lastTime = 0;
const unsigned long timerDelay = 16000;  // delay between updates in ms

// variables for soil moisture simulation
float soilMoisture = 15.0; 
const float moistureIncreaseRate = 1.0; 
const float moistureDecreaseRate = 0.5; 

void setup() {
  // initialize serial monitor
  Serial.begin(115200);

  // connect Wi-Fi
  Serial.print("Connecting to Wi-Fi");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWi-Fi connected.");

  // initialize ThingSpeak
  ThingSpeak.begin(client);
}

void loop() {
  if (millis() - lastTime > timerDelay) {
    // read the watering decision from Field 2
    int wateringDecision = ThingSpeak.readFloatField(decisionChannelNumber, 1, myReadAPIKey);
    if (wateringDecision == -1) {
      Serial.println("Error reading data from ThingSpeak.");
    } else {
      Serial.print("Watering Decision (Field 2): ");
      Serial.println(wateringDecision);

      // update soil moisture value based on watering decision
      if (wateringDecision == 1) {
        soilMoisture += moistureIncreaseRate;
        if (soilMoisture > 100.0) soilMoisture = 100.0; // cap at 100%
      } else {
        soilMoisture -= moistureDecreaseRate;
        if (soilMoisture < 0.0) soilMoisture = 0.0;     // cap at 0%
      }
      Serial.print("Soil Moisture (%): ");
      Serial.println(soilMoisture);

      // send the updated soil moisture to Field 1
      int responseCode = ThingSpeak.writeField(valueChannelNumber, 1, soilMoisture, myWriteAPIKey);
      if (responseCode == 200) {
        Serial.println("Soil moisture data sent successfully.");
      } else {
        Serial.println("Error sending soil moisture data. HTTP error code: " + String(responseCode));
      }
    }

    // update the timer
    lastTime = millis();
  }
}
