#include <Servo.h>

//Digital port
const byte thumbP= 5;
const byte midP = 6;
const byte topP = 9;
const byte botP = 10;
const byte linAct = 11;

//Analog ports
const byte ir = A0;
const byte thumbRes = A1;
const byte topRes = A2;
const byte midRes = A3;
const byte botRes = A4;

//Servo objects
Servo thumb;
Servo top;
Servo mid;
Servo bot;
Servo wrist; //Actually linear actuator


const int startPos = 30; //TODO find starting position

const int linLower = 1050; //Lower bound of the linear actuator
const int linUpper = 1950; //Upper bound of the linear actuator

const int irThresh = 800;

void setFingers(int th, int t, int m, int b){
  thumb.write(th);
  top.write(t);
  mid.write(m);
  bot.write(b);
}

void setup() {
  Serial.begin(9600);
  
  thumb.attach(thumbP);
  top.attach(topP);
  mid.attach(midP);
  //bot.attach(botP);
  wrist.attach(linAct);

  setFingers(0,180,90,0);
  wrist.writeMicroseconds(linLower);    
  
}

void loop() {
  
  int currIR = analogRead(ir);

  if (currIR < irThresh)
  {
    thumb.write(0); 
    top.write(180);   
    mid.write(0);  
    bot.write(180);
    wrist.writeMicroseconds(linUpper);
  }
   else
  {
    thumb.write(90);
    top.write(0);    
    mid.write(180);  
    bot.write(0);
    wrist.writeMicroseconds(linLower);    
  }
     
  delay(50);
  
}
