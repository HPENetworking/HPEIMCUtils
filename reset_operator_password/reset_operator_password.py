

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

""" This file will take the input of a operator name and allow an authenticated operator to change the password.


 This library uses the pyhpeimc python wrapper around the IMC RESTful API to automatically change the specified operator
 password."""




from pyhpeimc.auth import *
from pyhpeimc.plat.operator import *



auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")


set_operator_password('cyoung', password='newpass',auth=auth.creds,url=auth.url)