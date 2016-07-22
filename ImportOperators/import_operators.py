



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

""" This file will automatically load the contents of the imc_operator_list.csv file and create one new operator per row"


 This library uses the pyhpeimc python wrapper around the IMC RESTful API to automatically change the specified operator
 password."""

import csv
from pyhpeimc.auth import *
from pyhpeimc.plat.operator import *



auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")



def import_operator(filename='imc_operator_list.csv'):
    with open(filename) as csvfile:
        # decodes file as csv as a python dictionary
        reader = csv.DictReader(csvfile)
        try:
            for operator in reader:
                # loads each row of the CSV as a JSON string
                create_operator(operator, url=auth.url, auth=auth.creds)
        except:
            pass


import_operator()