#include <Arduino.h>

#define AOUT_PIN A0 // Arduino pin that connects to AOUT pin of moisture sensor
#define MOISTURE_MAX  470
#define MOISTURE_MIN  170

void setup() {
  Serial.begin(9600);
}

void loop() {
  int value = analogRead(AOUT_PIN); // read the analog value from sensor
  // soil moisture sensor reads flipped so lower numbers == higher moisture
  float normalizedValue =  ((float)(value - MOISTURE_MIN) / (float)(MOISTURE_MAX - MOISTURE_MIN)); 

  Serial.print("Moisture: ");
  Serial.println(normalizedValue);
  Serial.print("Regular Moisture: ");
  Serial.println(value);

  delay(3000);
}
