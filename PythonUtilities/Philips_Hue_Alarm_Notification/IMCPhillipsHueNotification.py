#!/usr/bin/env python3
# author: @netmanchris

""" Copyright 2015 Hewlett Packard Enterprise Development LP

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

   """

#   IMC create operators 1.0
#  Chris Young a.k.a @netmanchris
#
# Hewlett Packard Company    Revision 1.0

#Caution this is a proof of concept APP only,. You will definitly want to make sure you filter for ONLY the notifications
#that you actually want. Otherwise, this gets really annoying really quickly.

import time
from pyhpeimc.auth import *
from pyhpeimc.plat.alarms import *
from phue import Bridge

b = Bridge('10.101.0.153')
lights = b.get_light_objects('id')


yellow = [0.2972, 0.264]
red = [0.7425, 0.4196]
green = [0.41, 0.51721]
blue = [0.1691, 0.0441]
red1 = [0.6679, 0.3191]
purple = [0.4149, 0.1776]

lights[11].xy = purple
time.sleep(2)
lights[11].xy = yellow
time.sleep(2)
lights[11].xy = green
time.sleep(2)
lights[11].xy = blue

auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")




def create_alarm_list():
    x = get_alarms('admin', auth.creds, auth.url)
    alarm_list = []
    if len(x) is not 0:
        for i in x:
            alarm_list.append(i)
    return alarm_list



def alarm_state(alarm_list):
    alarm_state = 5
    for alarm in alarm_list:
        if int(alarm['alarmLevel']) < alarm_state:
            alarm_state = int(alarm['alarmLevel'])
    return alarm_state

def set_alarm_color(alarm_state):
        if alarm_state == 5:
            print("green")
            lights[11].xy = green
        elif alarm_state == 4:
            print("green")
            lights[11].xy = green
        elif alarm_state == 3:
            print("yellow")
            lights[11].xy = yellow
        elif alarm_state == 2:
            print("blue")
            lights[11].xy = blue
        elif alarm_state == 1:
            print ("red")
            lights[11].xy = red

past_state = None
def notify_lamp():
    while True:
        global past_state
        try:
            print ("It's try")
            alarm_list = create_alarm_list()
            current_state = alarm_state(alarm_list)
            print ("Current state is: "+str(current_state))
            print ("Past state is: "+ str(past_state))
            if current_state == past_state:
                print ("don't change state")
                notify_lamp()
            else:
                past_state = current_state
                print(current_state)
                print ("Change color to " + str(current_state))
                set_alarm_color(current_state)
                time.sleep(10)
        except:
            print ("it's except")
            print ("Set color to 5")
            set_alarm_color(5)
            time.sleep(10)
            notify_lamp()




notify_lamp()


