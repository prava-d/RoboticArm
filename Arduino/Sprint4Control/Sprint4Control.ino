#include <Servo.h>

// pins to connect sensors
const byte ir = A0;
const byte touch1 = A1;
const byte touch2 = A2;
const byte touch3 = A3;

// pins to connet servo
const byte motor1 = 3;
const byte motor2 = 5;
const byte motor3 = 6;
const byte motor4 = 10;

// sensor / threshold values
const int irthresh = 900;
const int touchthresh = 820;

// create Servo objects
Servo myservo1;
Servo myservo2;
Servo myservo3;
Servo myservo4;

void setup() {
  myservo1.attach(motor1);
  myservo2.attach(motor2);
  myservo3.attach(motor3);
  myservo4.attach(motor4);

  myservo1.write(0); //  (180 upright) // red right
  myservo2.write(0);  // (0 upright; 90 down, little slack) //wood
  myservo3.write(0);  //  (0 upright, 180 down, slack for most of this range,) // red middle
  myservo4.write(180);  //  (90 upright // orange 3

  
  Serial.begin(9600);
}

void loop() {
//  myservo1.write(180);
//  myservo2.write(0);
//  myservo3.write(120);
//  myservo4.write(130);

  Serial.println(analogRead(ir));

  if (analogRead(ir) < irthresh)
  {
    myservo1.write(0); 
    myservo2.write(90);   
    myservo3.write(180);  
    myservo4.write(0);  
  }
  else
  {
    myservo1.write(180);
    myservo2.write(0);
    myservo3.write(0);
    myservo4.write(180);
  }
  
}
