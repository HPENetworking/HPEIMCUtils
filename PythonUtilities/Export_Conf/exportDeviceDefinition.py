#!/usr/bin/env python3

import csv
from pyhpeimc.auth import *
from pyhpeimc.plat.device import *

IMC_IP="192.168.20.21"
IMC_PROTO="http://"
IMC_PORT="8080"
IMC_USER="imcrs"
IMC_PWD="imcrs"

authIMC = IMCAuth(IMC_PROTO, IMC_IP, IMC_PORT, IMC_USER, IMC_PWD)

def export_vendors(auth,csvFile,delimiter):
	vendors = get_system_vendors(auth.creds, auth.url)
	write_json_to_csv(vendors,csvFile,delimiter)
			
def export_categories(auth,csvFile,delimiter):
	categories = get_system_category(auth.creds, auth.url)
	write_json_to_csv(categories,csvFile,delimiter)

def export_models(auth,csvFile,delimiter):
	models = get_system_device_models(auth.creds, auth.url)
	write_json_to_csv(models,csvFile,delimiter)

def export_series(auth,csvFile,delimiter):
	series = get_system_series(auth.creds, auth.url)
	write_json_to_csv(series,csvFile,delimiter)

def write_json_to_csv(list,filename,delimiter):

	with open(filename, "w") as file:
		keys = list[0].keys()
		csv_file = csv.DictWriter(file,delimiter=delimiter,fieldnames=keys,lineterminator='\n')
		csv_file.writeheader()
		csv_file.writerows(list)

def get_system_series(auth, url):
    """Takes string no input to issue RESTUL call to HP IMC\n

      :param auth: requests auth object #usually auth.creds from auth pyhpeimc.auth.class

      :param url: base url of IMC RS interface #usually auth.url from pyhpeimc.auth.authclass

      :return: list of dictionaries where each dictionary represents a single device category

      :rtype: list

      >>> from pyhpeimc.auth import *

      >>> from pyhpeimc.plat.device import *

      >>> auth = IMCAuth("http://", "10.101.0.203", "8080", "admin", "admin")

      >>> series = get_system_series(auth.creds, auth.url)

      >>> type(series) is list
      True

    """
    get_system_series_url = '/imcrs/plat/res/series?managedOnly=false&start=0&size=10000&orderBy=id&desc=false&total=false'

    f_url = url + get_system_series_url
    # creates the URL using the payload variable as the contents
    r = requests.get(f_url, auth=auth, headers=HEADERS)
    # r.status_code
    try:
        if r.status_code == 200:
            system_series = (json.loads(r.text))
            return system_series['deviceSeries']
    except requests.exceptions.RequestException as e:
        return "Error:\n" + str(e) + " get_dev_series: An Error has occured"

		

export_vendors(authIMC,"vendors.csv",";")
export_categories(authIMC,"categories.csv",";")
export_models(authIMC,"models.csv",";")
export_series(authIMC,"series.csv",";")
