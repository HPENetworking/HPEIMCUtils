#!/usr/bin/env python3
# author: @netmanFabe

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

__author__ = "@netmanfabe"
__copyright__ = "Copyright 2016, Hewlett Packard Enterprise Development LP."
__credits__ = ["Fabien GIRAUD"]
__license__ = "Apache2"
__version__ = "2.0.0"
__maintainer__ = "Fabien GIRAUD"
__email__ = "fabien_giraud@me.com"
__status__ = "Prototype"

"""
import csv
from pyhpeimc.auth import *
import time
import datetime


headers = {'Accept': 'application/json', 'Content-Type':
    'application/json', 'Accept-encoding': 'application/json'}

authIMC = IMCAuth("http://", "192.168.20.21", "8080", "imcrs", "imcrs")

# Function to export alarms using IMC API filtered by recovery status and received time
#	Parameters:
#			username: IMC operator name which has access to the alarms
#			auth: IMC authentication credentials
#			url: IMC URL
#			rec: recovery status (0: not recovered ; 1: recovered)
#			startTime: received alarm time filter (only get alarm after startTime)
#	Returns a list of alarm (list of json items)
def export_alarms(username,auth, url, rec,startTime):

	timestamp_startTime = time.mktime(datetime.datetime.strptime(startTime, "%d/%m/%Y %H:%M:%S").timetuple())
	
	get_alarms_url = "/imcrs/fault/alarm?operatorName=" + username + "&recStatus=" + rec + "&startAlarmTime=" + str(timestamp_startTime) +"&timeRange=255&desc=false"
	f_url = url + get_alarms_url
	r = requests.get(f_url, auth=auth, headers=headers)
	# r.status_code
	try:
		if r.status_code == 200:
			alarm_list = (json.loads(r.text))
			return alarm_list['alarm']
	except requests.exceptions.RequestException as e:
			return "Error:\n" + str(e) + ' get_alarms: An Error has occured'


# Function to filter a list of alarm based on recovery time
#	Parameters:
#			alarm_list: list of alarm to filter (list of json items)
#			dateTime_begin: date Time filter for recovery time (keep only alarms recovered after this)
#	Returns a list of alarm (list of json items)
def filter_by_rectime(alarm_list,dateTime_begin):
	"""
	Function to filter a list of alarm  in order to keep alarms recovered after dateTime_begin
	dateTime_begin format : day/month/year hour:minute:second
	"""
	timstamp_begin = time.mktime(datetime.datetime.strptime(dateTime_begin, "%d/%m/%Y %H:%M:%S").timetuple())

	alarm_list_filtered = []
	for alarm in alarm_list:
		if int(alarm['recTime']) >= timstamp_begin:
			alarm_list_filtered.append(alarm)
	
	return alarm_list_filtered

# Function to convert json list to csv file
#	Parameters:
#			list: list of json object to convert
#			filename: file in which to write
#			delimiter: csv delimiter
def write_json_to_csv(list,filename,delimiter):

	with open(filename, "w") as file:
		keys = list[0].keys()
		csv_file = csv.DictWriter(file,delimiter=delimiter,fieldnames=keys,lineterminator='\n')
		csv_file.writeheader()
		csv_file.writerows(list)

# I used fixed parameters for recstatus, receivedtime and rectime, but we can also use command line arguments ...
fulllist = export_alarms('admin',authIMC.creds,authIMC.url,'1','19/09/2016 10:00:00')
#print("Hello %s" %(list))
filteredList = filter_by_rectime(fulllist,'20/09/2016 10:00:00')
#print(filteredList)
write_json_to_csv(filteredList,'recAlarm.csv',';')
