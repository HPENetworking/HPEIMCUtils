
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

""" This file will take the contents of perf_task.csv as input and automatically create new custom index tasks for SNMP
 Polling in the HPE IMC Network Management System

 This library uses the pyhpeimc python wrapper around the IMC RESTful API to automatically push the new performance tasks
 with minimal effort on the part of the user."""


import csv
import json

from pyhpeimc.auth import *
from pyhpeimc.plat.perf import *

auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")

'''
with open('perf_task.csv') as csvfile:
    perf_tasks = csv.DictReader(csvfile)
    for task in perf_tasks:
        print (json.dumps(task, indent = 4))
'''



with open('perf_task.csv') as csvfile:
    perf_tasks = csv.DictReader(csvfile)
    for task in perf_tasks:
        add_perf_task(task, auth.creds, auth.url)
        print ("Task Added Successfully")
'''


