
#**************************************************************************
# Identification:deploy_running_config_tftp
# Purpose:       depoly running configuration by tftp
#**************************************************************************

set timeout $very_long_timeout
send "save config from tftp $TFTPServer $TFTPFile merge\r"
expect { 
	   -re "TFTP Failed" {
		set ERROR_MESSAGE "Could not read file $TFTPFile from server $TFTPServer on $TFTPInterface"
		set ERROR_RESULT true
		expect $exec_prompt
	} -re "TFTP Succeeded" {
		set Testvalue true
	}
}
set timeout $standard_timeout