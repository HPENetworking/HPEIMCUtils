

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

""" This file will take the contents ofcustom_views.csv as input and automatically create new custom views in the HPE
 IMC Network Management System

 This library uses the pyhpeimc python wrapper around the IMC RESTful API to automatically push the new performance tasks
 with minimal effort on the part of the user."""


import csv
import time
from pyhpeimc.auth import *
from pyhpeimc.plat.groups import *


auth = IMCAuth("http://", "10.101.0.204", "8080", "admin", "admin")



records_list = []

with open('custom_views.csv') as csvfile:
        # decodes file as csv as a python dictionary
        reader = csv.DictReader(csvfile)
        for i in reader:
            records_list.append(i)

#Sorted funtion used to move upperviews the end of the list to ensure that the upperview exists before trying to create the child view.
#Note - May not work for hierarchies greater than two views.

records_list = sorted(records_list, key=lambda k: k['upperview'])

for view in records_list:
    # loads each row of the CSV as a JSON string
    name = view['name']
    upperview = view['upperview']
    if len(upperview) is 0:
        upperview = None
    create_custom_views(auth=auth.creds, url=auth.url, name=name, upperview=upperview)


