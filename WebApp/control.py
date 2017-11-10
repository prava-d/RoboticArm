from flask import Flask, render_template
import serial
import binascii

ser = serial.Serial('/dev//ttyACM0',9600)
app = Flask(__name__)

@app.route("/", methods=['GET', 'POST'])
def home():
    return render_template('home.html')


@app.route("/go",methods=['GET', 'POST'])
def cls():
    ser.write("go")
    return render_template('home.html')

@app.route("/stop", methods=['GET', 'POST'])
def opn():
    ser.write("stop")
    return render_template('home.html')

if __name__ == "__main__":
        app.run(host="0.0.0.0", port=8080)


