#include <Servo.h>

const byte linactuator = 3;
String result="";

Servo myservo;  // create servo object to control a servo
// twelve servo objects can be created on most boards

int pos = 0;    // variable to store the servo position

void setup() {
  //Setup input and outputs: LEDs out, pushbutton in.
  myservo.attach(3);
  Serial.begin(9600);
}

void loop() {
  pos = 1000;
  myservo.writeMicroseconds(pos);
  Serial.println(pos);
  delay(10000);
  /*for (pos = 1000; pos <= 2000; pos += 1) { // goes from 0 degrees to 180 degrees
    // in steps of 1 degree
    myservo.writeMicroseconds(pos);              // tell servo to go to position in variable 'pos'
    Serial.println(pos);
    delay(10);                       // waits 15ms for the servo to reach the position
  }*/
  /*pos = 2000;
  myservo.writeMicroseconds(pos);
  Serial.println(pos);
  delay(10000);*/
}
