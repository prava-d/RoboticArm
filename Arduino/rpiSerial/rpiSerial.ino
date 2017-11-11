#include <Servo.h>

const byte lin1 = 3;
const byte lin2 = 4;
const byte lin3 = 5;

Servo la1;
Servo la2;
Servo la3; 

String ser = "";
int pos = 1950;

void setup() {
  Serial.begin(9600);
  la1.attach(lin1);
  la2.attach(lin2);
  la3.attach(lin3);
  

}

void loop(){
  if (Serial.available() > 0) {
    ser = Serial.readString();
  } 

  if(ser=="go"){
    pos = 1050;
    la1.writeMicroseconds(pos);
    la2.writeMicroseconds(pos);
    la3.writeMicroseconds(pos);
  
  }

  if(ser=="stop"){
    pos = 1950;
    la1.writeMicroseconds(pos);
    la2.writeMicroseconds(pos);
    la3.writeMicroseconds(pos);
  
  }

  ser = "";
  delay(100);
}
