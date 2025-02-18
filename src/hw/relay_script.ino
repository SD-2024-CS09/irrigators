const int RELAY_PIN = 4;  // pin on the board, which connects to the IN pin of relay

void setup() {
  // initialize digital pin as an output
  pinMode(RELAY_PIN, OUTPUT);
}

void loop() {
  digitalWrite(RELAY_PIN, HIGH);
  delay(2000);
  digitalWrite(RELAY_PIN, LOW);
  delay(2000);
}