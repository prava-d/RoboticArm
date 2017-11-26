#include <Servo.h>

const byte blackFing = 8;
const byte whiteFing = 9;
const byte greyFing = 10;

Servo black;
Servo white;
Servo grey;

int pos = 100;
const byte mini = 50;
const byte maxi = 100;


void setup() {
  Serial.begin(9600);
//  black.attach(blackFing);
  white.attach(whiteFing);
//  grey.attach(greyFing);

//  black.write(mini);
  white.write(mini);
//  grey.write(mini);
  white.detach(whiteFing);

}

void loop() {
//  for(pos = 0; pos < maxi; pos++){
//    black.write(pos);
//    white.write(pos);
//    grey.write(pos);
//    delay(10);
//  }
//
//  delay(1000);
//  
//  for(pos = 200; pos > mini; pos--){
//    black.write(pos);
//    white.write(pos);
//    grey.write(pos);
//    delay(10);
//  }
//
//  delay(1000);

}
