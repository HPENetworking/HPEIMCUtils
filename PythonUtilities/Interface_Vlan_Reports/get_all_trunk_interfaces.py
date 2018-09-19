#!/usr/bin/env python3
# author: @netmanchris

"""
Copyright 2018 Hewlett Packard Enterprise Development LP.

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

from csv import DictWriter
from pyhpeimc.auth import *
from pyhpeimc.plat.device import *
from pyhpeimc.objects import *
from pyhpeimc.plat.vlanm import *


def find_target_vlan(auth, target_vlan):
    vlan_on_switch = []
    all_switches = get_all_devs(auth.creds, auth.url, category='1') #creates a list of all switches in the system
    for switch in all_switches:
        #print (switch['sysName'])
        try:
            dev_vlans = get_dev_vlans(auth.creds, auth.url, devid=switch['id'])  #gathers all vlans on individual switch
            for vlan in dev_vlans:
                if str(vlan['vlanId']) == str(target_vlan):   #checks to see if the target_vlan exists on the switch
                    vlan_on_switch.append(switch)    #if the target vlan exists, appends the switch to the vlan_on_switch list
        except:
            pass    #prevents program crash if device is not supported in the VLAN Manager
    return vlan_on_switch

def create_trunks_csv(auth, target_vlan):
    """
    Function takes input of auth and target vlan and creates a file with all devices for which the
    target_vlan is present on that specific device
    :param auth: pyhpeimc.auth.IMCAuth object
    :param target_vlan:  str or int representing the target VLAN ID
    :return: nothing is returned creates a CSV file with one entry for each switch where the target
    vlan exists
    """
    device_list = find_target_vlan(auth, target_vlan)
    trunk_interfaces = []
    for device in device_list:
        trunks = get_trunk_interfaces(auth.creds, auth.url,devid=device['id'])
        try:
            for trunk in trunks:
                interface = IMCInterface(device['ip'], trunk['ifIndex'],auth.creds, auth.url)
                interface_info = {'sysname' : interface.sysname,
                                  'sysdesc' : interface.sysdescription,
                                  'syslocation' : interface.location,
                                  'intname' : interface.name,
                                  'intdescription' : interface.description,
                                  'status' : interface.status,
                                  'lastchange' : interface.lastchange,
                                  'inttype' : 'trunk',
                                  'allowedVlans' : trunk['allowedVlans']}
                trunk_interfaces.append(interface_info)
        except:
            pass
    keys = trunk_interfaces[0].keys()
    for i in trunk_interfaces:
        if len(i) != len(trunk_interfaces[0].keys()):
            keys = trunk_interfaces[trunk_interfaces.index(i)].keys()
    with open('trunks_interfaces_vlan_'+ str(target_vlan)+'.csv', 'w', newline='') as csvfile:
        writer = DictWriter(csvfile, fieldnames=keys)
        writer.writeheader()
        writer.writerows(trunk_interfaces)

#edit this line to point to your own IMC server
auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")

#creates a list of all trunk interfaces for all devices where vlan '1' exist
create_trunks_csv(auth, '1')


