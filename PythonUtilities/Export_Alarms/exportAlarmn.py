#!/usr/bin/env python3

import csv
from pyhpeimc.auth import *
import time
import datetime
#from pyhpeimc.plat.alarm import *

HEADERS = {'Accept': 'application/json', 'Content-Type':
    'application/json', 'Accept-encoding': 'application/json'}


headers = {'Accept': 'application/json', 'Content-Type':
    'application/json', 'Accept-encoding': 'application/json'}

authIMC = IMCAuth("http://", "192.168.20.21", "8080", "imcrs", "imcrs")

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

def write_json_to_csv(list,filename,delimiter):

	with open(filename, "w") as file:
		keys = list[0].keys()
		csv_file = csv.DictWriter(file,delimiter=delimiter,fieldnames=keys,lineterminator='\n')
		csv_file.writeheader()
		csv_file.writerows(list)

fulllist = export_alarms('admin',authIMC.creds,authIMC.url,'1','19/09/2016 10:00:00')
#print("Hello %s" %(list))
filteredList = filter_by_rectime(fulllist,'20/09/2016 10:00:00')
#print(filteredList)
write_json_to_csv(filteredList,'recAlarm.csv',';')
