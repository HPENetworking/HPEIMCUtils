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

from pyhpeimc.auth import *
from pyhpeimc.plat.groups import *

auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")


def add_subnet_to_custom_views(network_range, view_name, auth, url):
    dev_list = get_all_devs(auth, url, network_address= network_range)
    current_devs = get_custom_view_details(view_name, auth, url)
    current_dev_ids = [i['id'] for i in current_devs]
    dev_id_list = [{'id': i} for i in current_dev_ids]
    for i in dev_list:
        dev_id = {'id' : i['id'] }
        if dev_id['id'] in current_dev_ids:
            print ("Already in the list")
        else:
            dev_id_list.append(dev_id)
            print("Not in the list")
    add_devs_custom_views(view_name, dev_id_list, auth, url)



add_subnet_to_custom_views('10.11.', "MobileFirst", auth.creds, auth.url)


current_devs = get_custom_view_details('MobileFirst', auth.creds, auth.url)


