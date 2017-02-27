

#!/usr/bin/env python3
# author: @netmanchris

"""
Copyright 2016 Hewlett Packard Enterprise Development LP.

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

""" This file will take the GET the contents of the HPE IMC Network Assets module and dump them into a CSV file called
all_assets.csv where each line of the CSV file represents one physical or logical asset as discovered by the HPE IMC
platform.


 This library uses the pyhpeimc python wrapper around the IMC RESTful API to automatically push the new performance tasks
 with minimal effort on the part of the user."""

import csv
from pyhpeimc.auth import *
from pyhpeimc.plat.device import *
from pyhpeimc.plat.termaccess import *

auth = IMCAuth("http://", "10.196.252.1", "8080", "admin", "admin")


all_devs = get_all_devs(auth.creds, auth.url)

def filter_icmp(all_devs):
    icmp_devs = []
    for dev in all_devs:
        if dev['categoryId'] == '9':
            icmp_devs.append(dev)
    return icmp_devs

icmp_devs = filter_icmp(all_devs)

for host in icmp_devs:
    locate = get_real_time_locate(host['ip'], auth.creds, auth.url)
    if type(locate) is list:
        if 'deviceIp' in locate[0]:
            int_details = get_interface_details( locate[0]['deviceId'],  locate[0]['ifIndex'], auth.creds, auth.url)
            dev_details = get_dev_details(locate[0]['deviceIp'], auth.creds, auth.url)
            host['SwitchIp'] = locate[0]['deviceIp']
            host['SwitchInt'] = locate[0]['ifDesc']
            host['intDescription'] = int_details['ifAlias']
            host['SwitchName'] = dev_details['label']
            host['SwitchType'] = dev_details['typeName']
            host['SwitchLocation'] = dev_details['location']
            host['SwitchContact'] = dev_details['contact']

    else:
        host['SwitchIp'] = 'Unknown'
        host['SwitchInt'] = 'Unknown'
    if 'mac' not in host:
        host['mac'] = "Unknown"
    if 'intDescription' not in host:
        host['intDescription'] = "Unknown"
    if 'SwitchName' not in host:
        host['SwitchName'] = "Unknown"
    if 'SwitchType' not in host:
        host['SwitchType'] = "Unknown"
    if 'SwitchLocation' not in host:
        host['SwitchLocation'] = "Unknown"
    if 'SwitchContact' not in host:
        host['SwitchContact'] = "Unknown"

final_list = [ {'hostLabel': i['label'],
                'hostIp': i['ip'],
                'hostMask' : i['mask'],
                'SwitchIntDesc' : i['intDescription'],
                'SwitchName' : i['SwitchName'],
                'SwitchType' : i['SwitchType'],
                'SwitchLocation' : i['SwitchLocation'],
                'SwitchContact' : i['SwitchContact'],
                'hostMac' : i['mac'],
                'SwitchIp' : i['SwitchIp'],
                'SwitchInt' : i['SwitchInt']}for i in icmp_devs ]

keys = final_list[0].keys()

for i in final_list:
    if len(i) >= len(final_list[0].keys()):
        keys = final_list[final_list.index(i)].keys()


with open ('icmp_devs.csv', 'w') as file:
    dict_writer = csv.DictWriter(file, keys)
    dict_writer.writeheader()
    dict_writer.writerows(final_list)



