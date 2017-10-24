#include <Servo.h>

// pins to connect touch sensor and IR sensor . . . could be changed
const byte irsensor = A0;
const byte touchsensor1 = A1;
const byte touchsensor2 = A2;
const byte touchsensor3 = A3;

const byte linactuator1 = 3;
const byte linactuator2 = 4;
const byte linactuator3 = 5;
String result="";

// need to change and calibrate values
int irthreshold = 400;
int touchthreshold = 900;

Servo myservo1;  // create servo object to control a servo
Servo myservo2;
Servo myservo3;  // twelve servo objects can be created on most boards

int pos = 0;    // variable to store the servo position

void setup() {
  //Setup input and outputs: LEDs out, pushbutton in.
  myservo1.attach(linactuator1);
  myservo2.attach(linactuator2);
  myservo3.attach(linactuator3);

  pinMode(irsensor, INPUT);
  
  Serial.begin(9600);
}

void loop() {
  pos = 1000;
  //myservo1.writeMicroseconds(pos);
  //myservo2.writeMicroseconds(pos);
  //myservo3.writeMicroseconds(pos);
  
  Serial.println(pos);
  delay(10000);

  // when it detects an object, need to calibrate
  if (analogRead(irsensor) > irthreshold) {
    for (pos = 1000; pos <= 2000; pos += 1) { // goes from 0 degrees to 180 degrees
      if (analogRead(touchsensor1) > touchthreshold or analogRead(touchsensor2) > touchthreshold or analogRead(touchsensor2) > touchthreshold) {
       break; 
      }
      // in steps of 1 degree
      myservo1.writeMicroseconds(pos);              // tell servo to go to position in variable 'pos'
      myservo2.writeMicroseconds(pos);
      myservo3.writeMicroseconds(pos);
      Serial.println(pos);
      delay(10);                       // waits 15ms for the servo to reach the position
    }
  }
  
  //pos = 2000;
  //myservo.writeMicroseconds(pos);
  Serial.println(pos);
  delay(10000);
}
