/* control code for sprint 3 deliverable
 */

#include <Servo.h>

// pins to connect touch sensor and IR sensor . . . could be changed
const byte ir = A0;
const byte touch1 = A1;
const byte touch2 = A2;
const byte touch3 = A3;

// pins to connect the servos . . . could be changed
const byte motor1 = 3;
const byte motor2 = 9;
const byte motor3 = 10;

// threshold values for the ir sensor and the touch sensor . . . might need to be changed
const int irthresh = 940;
const int touchthresh = 820;

// create servo objects
Servo myservo1;
Servo myservo2;
Servo myservo3;

const int maxclose = 120;
bool doOpen = true;

String result;

// other variables
int pos = 0;

void setup() {
  // put your setup code here, to run once:

  myservo1.attach(motor1);
  myservo2.attach(motor2);
  myservo3.attach(motor3);

//  pinMode(ir, INPUT);

//pinMode(touch1, INPUT);

  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:

//  Serial.println("ir: " + ir);
//  Serial.println("touch1: " + touch1);
//  Serial.println("touch2: " + touch2);
//  Serial.println("touch3: " + touch3);

//for (pos = 0; pos <= 90; pos ++)
//{
////  myservo1.write(pos);
////  myservo2.write(pos);
////  myservo3.write(pos);
//  delay(100);
//}
//


/* code we want */
//Serial.println(analogRead(ir));

if (analogRead(ir) < irthresh)
{
  for (pos = 0; pos <= maxclose; pos++)
  {
    if (analogRead(touch1) < touchthresh)
    {
      myservo1.write(min(pos+15,maxclose));
    }
    if (analogRead(touch2) < touchthresh)
    {
      myservo2.write(min(pos+30,maxclose));
    }
    if (analogRead(touch3) < touchthresh)
    {
      myservo3.write(min(pos,maxclose));
    }
    delay(20);
  }
  delay(3000);
  doOpen = true;
}
else
{
  myservo1.write(0);
  delay(100);
  myservo2.write(0);
  delay(100);
  myservo3.write(0);
  delay(100);
}

if (doOpen){
  myservo1.write(0);
  delay(100);
  myservo2.write(0);
  delay(100);
  myservo3.write(0);
  delay(100);
  delay(500);
  doOpen=false;
}

result = "";
result = result + "Touch1: " + analogRead(touch1) + " | " + "Touch2: " + analogRead(touch2) + " | " + "Touch3: " + analogRead(touch3) + " | " + "IR: " + analogRead(ir);
Serial.println(result);

delay(50);



//  for (pos = 0; pos <= 200; pos ++)
//  {
//    myservo1.write(pos);
    
//    delay(10);
//    Serial.println("motor2: " + motor2);
//    Serial.println("motor3: " + motor3);
//  }

  

}
