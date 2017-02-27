

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
from pyhpeimc.plat.vlanm import *

auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")


all_devices = get_all_devs(auth.creds, auth.url)

interesting_devices = []

for device in all_devices:
    if device['sysOid'] == '1.3.6.1.4.1.11.2.3.7.11.160':
        interesting_devices.append(device)

all_results = []
for switch in interesting_devices:
    interfaces = get_all_interface_details(switch['id'], auth.creds, auth.url)
    access_interfaces = get_device_access_interfaces(switch['id'], auth.creds, auth.url)
    for i in interfaces:
        results = {}
        results['switchName'] =  switch['sysName']
        results['switchIp'] = switch['ip']
        results['switchMask'] = switch['mask']
        results['location'] = switch['location']    #assumes syslocation was set on device
        results['switchModel'] = switch['typeName']
        if i['ifDescription'] == "A17":
            results['Interface'] = i['ifDescription']
            results['Description'] = i['ifAlias']
            ifindex = i['ifIndex']
            for i in access_interfaces:
                if i['ifIndex'] == ifindex:
                    results['pvid'] = i['pvid']
            all_results.append(results)




keys = all_results[0].keys()

for i in all_results:
    if len(i) != len(all_results[0].keys()):
        keys = all_results[all_results.index(i)].keys()

with open ('all_results.csv', 'w') as file:
    dict_writer = csv.DictWriter(file, keys)
    dict_writer.writeheader()
    dict_writer.writerows(all_results)




