#include <Servo.h>

// pins to connect touch sensor and IR sensor . . . could be changed
const byte irsensor = A0;
const byte touchsensor1 = A1;
const byte touchsensor2 = A2;
//const byte touchsensor3 = A3;

const byte linactuator1 = 3;
const byte linactuator2 = 5;
const byte linactuator3 = 6;
const int maxclose = 1600;
String result="";

bool handclosed = true;

// need to change and calibrate values
int irthreshold = 970;
int touchthreshold = 950;

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
  if(handclosed){
    pos = 2000;
    myservo1.writeMicroseconds(pos);
    delay(800);
    myservo3.writeMicroseconds(pos);
    delay(800);
    myservo2.writeMicroseconds(pos);
    
    //Serial.println(pos);
    delay(7000);
    handclosed = false;
  }
  result = result + analogRead(irsensor) + "|" + analogRead(touchsensor1) + "|" + analogRead(touchsensor2);
  Serial.println(result);
  result = "";
  // when it detects an object, need to calibrate
  if (analogRead(irsensor) < irthreshold) {
    for (pos = 2000; pos >= maxclose-50; pos -= 1) { // goes from 0 degrees to 180 degrees
      if (analogRead(touchsensor1) < touchthreshold or analogRead(touchsensor2) < touchthreshold) {
        break; 
      }
      result = result + analogRead(touchsensor1) + "|" + analogRead(touchsensor2) + "|" + pos;
      Serial.println(result);
      result = "";
        // in steps of 1 degree
      myservo2.writeMicroseconds(max(pos, maxclose));              // tell servo to go to position in variable 'pos'
      myservo3.writeMicroseconds(max(2000-(2000-pos)*5/3, 2000-(2000-maxclose) * 5/3));
      myservo1.writeMicroseconds(max(pos+50, maxclose));
      delay(30);
    //Serial.println(pos);
    //delay(2000);                       // waits 15ms for the servo to reach the position
    }
    handclosed = true;
  }
  if(handclosed){
    delay(5000);
  }
  delay(50);
  
}
