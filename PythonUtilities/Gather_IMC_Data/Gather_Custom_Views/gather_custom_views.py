

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
from pyhpeimc.plat.groups import *

auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")


all_views = get_custom_views(auth.creds, auth.url)

export_views = []

child_views = []

def find_view_name(viewId, view_list):
    for view in view_list:
        #print ("This is the ID: " + view['symbolId'])
        #print (type(view['symbolId']))
        if viewId == view['symbolId']:
            #print ("This is the view name: " + view['name'])
            return view['name']

for view in all_views:
    custom_view = {}
    custom_view['name'] = view['name']
    if 'upLevelSymbolId' in view:
        custom_view['upperview'] = find_view_name(view['upLevelSymbolId'], all_views)
        print (type(custom_view['upperview']))
        if type(custom_view['upperview'] is str):
            child_views.append(custom_view)
            print (" Child views is : " + str(child_views))
        else:
            export_views.append(custom_view)
            print (" export_views is :" + str(export_views))



for custom_view in child_views:
    export_views.append(custom_view)





keys = export_views[0].keys()

for i in export_views:
    if len(i) >= len(export_views[0].keys()):
        keys = export_views[export_views.index(i)].keys()

with open ('custom_views.csv', 'w') as file:
    dict_writer = csv.DictWriter(file, keys)
    dict_writer.writeheader()
    dict_writer.writerows(export_views)



