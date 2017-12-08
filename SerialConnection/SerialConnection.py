from serial import Serial, SerialException


cxn = Serial('/dev/ttyACM0', baudrate=9600)

count = 0;
while(True):
    try:
        cxn.write([1])
        while cxn.inWaiting() < 1:
            pass
        result = str(cxn.readline());
        result = result.strip().split("|");
        print(result)
    except ValueError:
        print "The Arduino Returned an Incorrect Value"
