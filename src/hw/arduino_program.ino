// Use Serial1 for UART communication with Arduino
#include <Arduino.h>
#define AOUT_PIN A0 // Arduino pin that connects to AOUT pin of moisture sensor
#define MOISTURE_MAX  448
#define MOISTURE_MIN  178

void setup() {
    Serial.begin(9600);
}

void loop() {
    int value = analogRead(AOUT_PIN); // read the analog value from sensor
    // soil moisture sensor reads flipped so lower numbers == higher moisture
    float normalizedValue = 1 - ((float)(value - MOISTURE_MIN) / (float)(MOISTURE_MAX - MOISTURE_MIN));
    if (normalizedValue > 1){
        normalizedValue = 1;
    } 
    else if (normalizedValue < 0){
        normalizedValue = 0;
    }
  
    Serial.println(String(normalizedValue));

    delay(3000);
}