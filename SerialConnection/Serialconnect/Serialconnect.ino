//bool sent = 0; //If data has been sent (and thus motor can move to next position)
String result=""; //result, to be print in the Serial
const byte CMD_READ_IR = 1;
byte cmd_id = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available() > 0) {
    cmd_id = Serial.read();
  } else {
    cmd_id = 0;
  }
  
  switch(cmd_id){
    case CMD_READ_IR:
      result = result + 1 + "|" + 2;
      Serial.println(result);
      //sent = true; //notify motor to move
      break;
    default:
      result = result + 0;
      Serial.println(result);
      //sent = true; //notify motor to move
      break;
    break;
  }
  result = ""; //reset result 
}
