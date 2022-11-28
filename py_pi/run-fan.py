#!/usr/bin/env python

#########################
#
# run-fan turns a fan on and off when temperature exceeds temperature
# thresholds.
#
# The fan comes with a MiuZei case, and can run on 3.3V (low speed) or
# 5V (high speed). The fan can be plugged into either 3.3V or 5.5v GPIO
# pin and to a ground GPIO pin, but that means the fan will always run
# and that isn't very much fun. Any fan can be used as long it can operate 
# at 3.3V
#
# run-fan was tested on a raspberry pi running kodi on osmc using a 3.3v
# GPIO
#
#########################

#########################
#
# run-fan requires an S8050 NPN transistor and a resistor to be connected
# as follows:
#   flat side of S8050 faces this way >
#   S8050 pin c: connects to black (-) wire on fan
#   S8050 pin b: connects to 110 Ohm Resistor and to GPIO pin 25
#   S8050 pin e: connects to ground GPIO pin
#   fan red (+): connects to 3.3v GPIO pin on raspberry pi 3
#
# GPIO pin 25 is used, but it can be changed
#
#########################

#########################
#
# run-fan starts automatically using systemd
#
# Create a systemd service file using:
#   $ sudo nano /lib/systemd/system/run-fan.service
#
# with the contents as shown below
# remove # and leading spaces:
#   [Unit]
#   Description=run fan when hot
#   After=meadiacenter.service
#
#   [Service]
#   # If User and Group are not specified as root, then it won't work
#   User=root
#   Group=root
#   Type=simple
#   ExecStart=/usr/bin/python /home/osmc/run-fan.py
#   Restart=Always
#
#   [Install]
#   WantedBy=multi-user.target
#
# end of the run-fan.service
# ctrl-o, ENTER, ctrl-x to save and exit the nano editor
#
# After any changes to /lib/systemd/system/run-fan.service:
#    sudo systemctl daemon-reload
#    sudo systemctl enable run-fan.service
#    sudo reboot
#
# Ensure the run-fan.service in systemd is enabled and running:
#    systemctl list-unit-files | grep enabled
#    systemctl | grep running | grep fan
#    systemctl status run-fan.service -l
#
# If there are any issues with starting the script using systemd, 
# then examine the journal using:
#    sudo journalctl -u run-fan.service
#
#########################

#########################
#
# The original script is from:
#    Author: Edoardo Paolo Scalafiotti <edoardo849@gmail.com>
#    Source: https://hackernoon.com/how-to-control-a-fan-to-cool-the-cpu-of-your-raspberrypi-3313b6e7f92c
#
#########################

#########################
import os
import time
import signal
import sys
import RPi.GPIO as GPIO
import datetime

#########################
sleepTime = 15	# Time to sleep between checking the temperature
                # want to write unbuffered to file
fileLog = open('/home/al/run-fan.log', 'w+')

#########################
# Log messages should be time stamped
def timeStamp():
    t = time.time()
    s = datetime.datetime.fromtimestamp(t).strftime('%Y/%m/%d %H:%M:%S - ')
    return s

# Write messages in a standard format
def printMsg(s):
    fileLog.write(timeStamp() + s + "\n")

#########################
class Pin(object):
    pin = 25        # GPIO or BCM pin number to turn fan on and off
    PWM_FREQ = 25  # [Hz] Change this value if fan has strange behavior

    def __init__(self):
        try:
            GPIO.setmode(GPIO.BCM)
            GPIO.setup(self.pin, GPIO.OUT, initial=GPIO.LOW)
            GPIO.setwarnings(False)
            self.fan = GPIO.PWM(self.pin, self.PWM_FREQ)
            self.fan.start(0)
            printMsg("Initialized: run-fan using GPIO pin: " + str(self.pin))
        except:
            printMsg("If method setup doesn't work, need to run script as sudo")
            exit

    def drive(self, fanSpeed):
        self.fan.ChangeDutyCycle(fanSpeed)

    # resets all GPIO ports used by this program
    def exitPin(self):
        GPIO.cleanup()

    def set(self, state):
        GPIO.output(self.pin, state)

# Fan class
class Fan(object):
    fanOff = True

    def __init__(self):
        self.fanOff = True

    # Turn the fan on or off
    def setFan(self, temp, on, myPin):
        if on:
            printMsg("Turning fan on " + str(temp))
        else:
            printMsg("Turning fan off " + str(temp))
        myPin.set(on)
        self.fanOff = not on

# Temperature class
class Temperature(object):
    cpuTemperature = 0.0
    startTemperature = 0.0
    stopTemperature = 0.0
    
    i = 0
    fanSpeed = 0
    cpuTempOld = 0
    fanSpeedOld = 0
    FAN_MIN = 35

    # Configurable temperature and fan speed steps
    tempSteps = [40, 70]  # [°C]
    speedSteps = [35, 100]  # [%]

    # Fan speed will change only of the difference of temperature is higher than hysteresis
    hyst = 1

    def __init__(self):
        # Start temperature in Celsius
        #   Maximum operating temperature of Raspberry Pi 3 is 85C
        #   CPU performance is throttled at 82C
        #   running a CPU at lower temperatures will prolong its life
        self.startTemperature = 50.0

        # Wait until the temperature is M degrees under the Max before shutting off
        self.stopTemperature = self.startTemperature - 5.0

        printMsg("Start fan at: " + str(self.startTemperature))
        printMsg("Stop fan at: " + str(self.stopTemperature))

    def getTemperature(self):
        # need to specify path for vcgencmd
        res = os.popen('/opt/vc/bin/vcgencmd measure_temp').readline()
        self.cpuTemperature = float((res.replace("temp=","").replace("'C\n","")))

    # Using the CPU's temperature, turn the fan on or off
    def checkTemperature(self, myFan, myPin):
        self.getTemperature()
        # Calculate desired fan speed
        if abs(self.cpuTemperature - self.cpuTempOld) > self.hyst:
            # Below first value, fan will run at min speed.
            if self.cpuTemperature < self.tempSteps[0]:
                self.fanSpeed = self.speedSteps[0]
            # Above last value, fan will run at max speed
            elif self.cpuTemperature >= self.tempSteps[len(self.tempSteps) - 1]:
                self.fanSpeed = self.speedSteps[len(self.tempSteps) - 1]
            # If temperature is between 2 steps, fan speed is calculated by linear interpolation
            else:
                for self.i in range(0, len(self.tempSteps) - 1):
                    if (self.cpuTemperature >= self.tempSteps[self.i]) and (self.cpuTemperature < self.tempSteps[self.i + 1]):
                        sS = self.speedSteps[self.i + 1] - self.speedSteps[self.i]
                        tS = self.tempSteps[self.i + 1] - self.tempSteps[self.i]
                        rT = self.cpuTemperature - self.tempSteps[self.i]
                        self.fanSpeed = round(sS / tS * rT + self.speedSteps[self.i], 1)
            if self.fanSpeed != self.fanSpeedOld:
                if (self.fanSpeed != self.fanSpeedOld and (self.fanSpeed >= self.FAN_MIN or self.fanSpeed == 0)):
                    myPin.drive(self.fanSpeed)
                    self.fanSpeedOld = self.fanSpeed
            cpuTempOld = self.cpuTemperature
#        if self.cpuTemperature > self.startTemperature:
            # need to turn fan on, but only if the fan is off
#            if myFan.fanOff:
#                myFan.setFan(self.cpuTemperature, True, myPin)
        myFan.setFan(self.cpuTemperature, True, myPin)
        print(self.fanSpeed, self.cpuTemperature)
#        elif self.cpuTemperature <= self.stopTemperature:
#            # need to turn fan off, but only if the fan is on
#            if not myFan.fanOff:
#                myFan.setFan(self.cpuTemperature, False, myPin)

#########################
printMsg("Starting: run-fan")
try:
    myPin = Pin()
    myFan = Fan()
    myTemp = Temperature()
    while True:
        myTemp.checkTemperature(myFan, myPin)

        # Read the temperature every N sec (sleepTime)
        # Turning a device on & off can wear it out
        time.sleep(sleepTime)

except KeyboardInterrupt: # trap a CTRL+C keyboard interrupt
    printMsg("keyboard exception occurred")
    myPin.exitPin()
    fileLog.close()

except:
    printMsg("ERROR: an unhandled exception occurred")
    myPin.exitPin()
    fileLog.close()
