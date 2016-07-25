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

from pyhpeimc.auth import *
from TwitterAPI import TwitterAPI
from pyhpeimc.plat.alarms import *
import time

auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")

# Navigate to https://apps.twitter.com and create a new app to get your own consumer and access tokens

CONSUMER_KEY = 'GET_FROM_TWITTER'
CONSUMER_SECRET = 'GET_FROM_TWITTER'
ACCESS_TOKEN_KEY = 'GET_FROM_TWITTER'
ACCESS_TOKEN_SECRET = 'GET_FROM_TWTTER'


# If you are behind a firewall you may need to provide proxy server
# authentication.
proxy_url = None  # Example: 'https://USERNAME:PASSWORD@PROXYSERVER:PORT'

# Using OAuth 1.0 to authenticate you have access all Twitter endpoints.
# Using OAuth 2.0 to authenticate you lose access to user specific endpoints (ex. statuses/update),
# but you get higher rate limits.
api = TwitterAPI(CONSUMER_KEY,
                 CONSUMER_SECRET,
                 ACCESS_TOKEN_KEY,
                 ACCESS_TOKEN_SECRET,
                 auth_type='oAuth1',
                 proxy_url=proxy_url)
#api = TwitterAPI(CONSUMER_KEY, CONSUMER_SECRET, auth_type='oAuth2', proxy_url=proxy_url)

alarm_list = []

def create_alarm_list():
    global alarm_list
    x = get_alarms('admin', auth.creds, auth.url)
    alarm_list = []
    if len(x) is not 0:
        for i in x:
            if i in alarm_list:
                continue
            else:
                if int(i['alarmLevel']) < 3:
                    alarm_list.append(i)

#posts TWEET_TEXT to Twitter API
def send_tweet():
    for i in alarm_list:
        if int(i['alarmLevel']) < 3:
               alarm = " d @netmanchris dev:" + i['deviceName'] + ", Sev:" + i['alarmLevel'] + ", " + i['alarmDesc']
               r = api.request('statuses/update', {'status': alarm[0:139]})
               print (r.status_code)
               print (r.text)

def notify_twitter():
    while True:
        try:
            create_alarm_list()
            send_tweet()
            time.sleep(60)
        except:
            time.sleep(60)
            notify_twitter()

def check_twitter_rate_limit():
    r = api.request('application/rate_limit_status')
    print(r.status_code)
    j = r.response.json()
    print(j['resources']['search'])
