import serial_ext
from serial import Serial, SerialException


cxn = Serial('/dev/ttyACM0', baudrate=9600)
info = serial_ext.Information();
info.set(0);

count = 0;
while(True):
    info.update();
    try:
        cxn.write([info.get()])
        while cxn.inWaiting() < 1:
            pass
        result = str(cxn.readline());
        result = result.strip().split("|");
        print(result)
    except ValueError:
        print "The Arduino Returned an Incorrect Value"
