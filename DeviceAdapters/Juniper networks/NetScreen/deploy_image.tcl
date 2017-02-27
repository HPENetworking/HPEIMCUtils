
#**************************************************************************
# Identification:deploy_image_cli.tcl
# Purpose:       deploy image to device by cli
#**************************************************************************

set timeout $very_long_timeout
set WARNING_RESULT true

send "save config to tftp $TFTPServer backup.cfg"
expect {
		-re "TFTP Succeeded" {
		} -re "Failed" {
			set ERROR_RESULT true
			set ERROR_MESSAGE "Could not backup configuration file to TFTPServer: $TFTPServer."
			expect -re exec_prompt
		}
	}
send "\r"
expect -re $exec_prompt
send "save software from tftp $TFTPServer $TFTPFile to flash\r"

    expect {
	-re "tftp success!" {
	} -re " failed" {
		set ERROR_RESULT true
		set ERROR_MESSAGE "Could not copy image from TFTP server. Image did not exist or content was invalid."
		expect -re $exec_prompt
	}
		
}


set timeout $standard_timeout
if { $ERROR_RESULT != "true" } {
	set WARNING_RESULT false
}			