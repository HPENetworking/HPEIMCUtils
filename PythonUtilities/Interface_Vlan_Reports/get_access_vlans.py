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

device_name_list = ["HP", "EI", "Cisco"]
def create_target_switch_list(auth, switch_names):
    switch_list = []
    for name in switch_names:
        switches = get_all_devs(auth.creds, auth.url, label=name, category='1')
        for switch in switches:
            if switch['id'] in switch_list:
                pass
            else:
                switch_list.append({'id' : switch['id'], 'ip' : switch['ip']})
    return switch_list



def find_target_vlan(auth, switchlist, target_vlan):
    vlan_on_switch = []
    for switch in switchlist:
        #print (switch['sysName'])
        try:
            dev_vlans = get_dev_vlans(auth.creds, auth.url, devid=switch['id'])  #gathers all vlans on individual switch
            for vlan in dev_vlans:
                if str(vlan['vlanId']) == str(target_vlan):   #checks to see if the target_vlan exists on the switch
                    vlan_on_switch.append(switch)    #if the target vlan exists, appends the switch to the vlan_on_switch list
        except:
            pass    #prevents program crash if device is not supported in the VLAN Manager
    return vlan_on_switch

def create_access_ports_csv(auth, device_list_with_target_vlan, target_vlan):
    access_interfaces_list = []
    for device in device_list_with_target_vlan:
        #print (device)
        accessinterfaces = get_device_access_interfaces(auth.creds, auth.url, devid=device['id'])
        try:
            for interface in accessinterfaces:
                if (interface['pvid'] == str(target_vlan)):
                    #print (interface)
                    imcint = IMCInterface(device['ip'], interface['ifIndex'], auth.creds, auth.url)
                    interface_info = {'sysname': imcint.sysname,
                                      'sysdesc': imcint.sysdescription,
                                      'syslocation': imcint.location,
                                      'intname': imcint.name,
                                      'intdescription': imcint.description,
                                      'status': imcint.status,
                                      'lastchange': imcint.lastchange,
                                      'inttype': 'access',
                                      'pvid': interface['pvid']}
                    #print(interface_info)
                    access_interfaces_list.append(interface_info)
        except:
            pass  #prevents crashing when device is not present or data doesn't exist in database
    #print (access_interfaces_list)
    keys = access_interfaces_list[0].keys()
    for i in access_interfaces_list:
        if len(i) != len(access_interfaces_list[0].keys()):
            keys = access_interfaces_list[access_interfaces_list.index(i)].keys()
    with open('access_interfaces_vlan_' + str(target_vlan) + '.csv', 'w', newline='') as csvfile:
        writer = DictWriter(csvfile, fieldnames=keys)
        writer.writeheader()
        writer.writerows(access_interfaces_list)


#find devices with X in their name AND where the target VLAN exists on the device and spits out a CSV with all access ports
#which have the target VLAN as the PVID on the access port

#Edit this line to point to your own IMC server
auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")



#Device list contains a list strings which may appear in the device label
#If the string appears anywhere in the device lable, it should be added to the list
device_name_list = ['EI', 'Cisco']

#variable is the target VLAN for which we're trying to locate access interfaces
target_vlan = '1'
#this command first creates a list of the target devices based on the
#device_name_list variable above
device_list = create_target_switch_list(auth, device_name_list)
#this command takes the potential target devices and filters them for only
#the devices where the VLAN exists
device_list_with_target_vlan = find_target_vlan(auth, device_list, target_vlan)
#this command takes an input of the filtered list, gathers all the access interfaces
#on those devices who's PVID is equal to the target_vlan and writes them out to a CSV file
create_access_ports_csv(auth, device_list_with_target_vlan, target_vlan)
