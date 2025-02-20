/* script to connect our esp32 to GU Wifi given that the MAC address has been registered */
/* ensure to fillout credentials appropriately */

#include <WiFi.h> 
#include "esp_wpa2.h" 

#define EAP_IDENTITY "<gu username>"
#define EAP_PASSWORD "<password>"
#define EAP_USERNAME "<gu username>"

const char* ssid = "Gonzaga Community"; 

void setup() {
  Serial.begin(115200);
  delay(10);
  Serial.print(F("Connecting to network: "));
  Serial.println(ssid);
  WiFi.disconnect(true); 

  WiFi.begin(ssid, WPA2_AUTH_PEAP, EAP_IDENTITY, EAP_USERNAME, EAP_PASSWORD); 
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(F("."));
  }
  Serial.println("");
  Serial.println(F("WiFi is connected!"));
  Serial.println(F("IP address set: "));
  Serial.println(WiFi.localIP()); 
}

void loop() {
  yield();
}

