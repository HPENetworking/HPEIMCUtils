#!/usr/bin/env python3
# author: @netmanchris

""" Copyright 2018 Hewlett Packard Enterprise Development LP

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
# Download the Python helper library from twilio.com/docs/python/install
from twilio.rest import Client
from pyhpeimc.auth import *
from pyhpeimc.plat.alarms import *

# Your Account Sid and Auth Token from twilio.com/user/account
account_sid = "FILLTHISINWITHYOURACCOUNTSIDEFROMTWILIO"
auth_token = "FILLTHISINWITHYOURACCOUNTAUTHTOKENFROMTWILIO"
client = Client(account_sid, auth_token)

#This section wil collect current alarms from the IMC API
#MAKE SURE TO CHANGE THIS TO YOUR IMC IP ADDRESS/DNS NAME AND YOUR USERNAME AND PASSWORD
auth = IMCAuth("http://", "10.101.0.204", "8080", "admin", "admin")

alarm_list = get_realtime_alarm('admin', auth.creds, auth.url)


def send_sms(alarm_list):
    for i in alarm_list:
        if int(i['severity']) < 3:
               alarm = i['deviceDisplay'] + ", Sev:" + i['severity'] + ", " + i['faultDesc']
                #print (alarm)
               client.api.account.messages.create(
                   to="+15142440868",
                   from_="+15146003692",
                   body= alarm)

def notify_twilio():
   while True:
       try:
           create_alarm_list()
           send_sms()
           time.sleep(60)
       except:
           time.sms(60)
           notify_twilio()



