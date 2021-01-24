// PING workshop (EARS)

void setup() {
  Serial.begin(9600);
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  
}

void loop() {
  // put your main code here, to run repeatedly:
  int pot1 = analogRead(A0);
  int pot2 = analogRead(A1);

  Serial.print(pot1);
  Serial.print(",");
  Serial.println(pot2);
 // Serial.println();
    
  delay(20);
}
