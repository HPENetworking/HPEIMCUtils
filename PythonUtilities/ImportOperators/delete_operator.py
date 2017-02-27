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
from pyhpeimc.plat.operator import *



auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")



ops_list = ['cyoung', 'lstuart', 'clinzell', 'kgott', 'rkauffman', 'lknapp', 'dwenger', 'jmacdonald', 'tkubica', 'mbreen', 'mventer','ksecino']

for operator in ops_list:
    delete_plat_operator(operator,url=auth.url, auth=auth.creds)


