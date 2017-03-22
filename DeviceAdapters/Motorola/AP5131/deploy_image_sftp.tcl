
#**************************************************************************
# Identification:deploy_image_cli.tcl
# Purpose:       deploy image to device by cli
#**************************************************************************


set timeout $squeeze_timeout

set loop true
if { [string first primary $slot] >= 0 } {
   send -s "put \"$TFTPFile\" /os/primary\r"
} else {
   send -s "put \"$TFTPFile\" /os/secondary\r"
}
	
while { $loop == "true" } {
	expect {
	    #PUTTY error info
		"Network error" {
			expect -re $exec_prompt
			set ERROR_RESULT true
			set ERROR_MESSAGE "Failed to contact sftp server; network may be down."
			set loop false
		} "FATAL ERROR:" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "FATAL ERROR."
			set loop false
		} "Fatal:" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "FATAL ERROR."
			set loop false
		} "Unable to transfer file completely" {
			expect -re $exec_prompt
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Device aborted the file transfer."
			set loop false
		} "unable to open" {
		   set ERROR_RESULT  true
		   set ERROR_MESSAGE "Unable to open local file."
		   set loop false
		} "open for read: failure" {
		   set ERROR_RESULT  true
		   set ERROR_MESSAGE "open for read: failure."
		   set loop false
		} "open for write: failure" {
		   set ERROR_RESULT  true
		   set ERROR_MESSAGE "open for write: failure."
		   set loop false
		} "unknown command" {
		   set ERROR_RESULT  true
		   set ERROR_MESSAGE "unknown command."
		   set loop false
		} "connection is closed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "connection is closed."
			set loop false
		} "Invalid command" {
            #linux ssh error info
		   set ERROR_RESULT  true
		   set ERROR_MESSAGE "Invalid command."
		   set loop false
		} "File * not found" {
		   set ERROR_RESULT  true
		   set ERROR_MESSAGE "File not found."
		   set loop false
		} "Connection closed" {
		   set ERROR_RESULT  true
		   set ERROR_MESSAGE "Connection closed."
		   set loop false
		} "No such file or directory" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "No such file or directory."
			set loop false
		} "Received disconnect" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Received disconnect."
			set loop false
		} "Missing argument" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Missing argument."
			set loop false
		} "Opening remote file failed" {
		#Bitverse
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Opening remote file failed."
			set loop false
		} "Opening local file failed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Opening local file failed."
			set loop false
		} "file failed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "file failed."
			set loop false
		} "Creating local directory failed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Creating local directory failed."
			set loop false
		} "Invalid command option" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Invalid command option."
			set loop false
		} -re $sftp_exec_prompt {
			set loop false
		}
	}
}

sleep 300
set timeout $standard_timeout	