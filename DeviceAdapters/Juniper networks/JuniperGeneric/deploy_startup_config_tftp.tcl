
#**************************************************************************
# Identification:deploy_startup_config_tftp
# Purpose:       depoly startup configuration by tftp
#**************************************************************************

set timeout $very_long_timeout
send "start shell\r"
expect 	{ 
		-re "(.*?%)" { 
		send "echo 'ascii' | echo 'rexmt 1' | echo 'timeout 20' | echo 'get $TFTPFile $config_filename' | tftp $TFTPServer\r"
		expect {
			"unknown command" {
				set ERROR_MESSAGE "Error attempting operation.  Bad command or invalid permissions."
				set ERROR_RESULT true
    		} "tftp: No address associated with hostname" {
				set ERROR_MESSAGE "Error attempting operation.  Bad command or invalid permissions."
				set ERROR_RESULT true
			} "Transfer timed out." {
				set ERROR_MESSAGE "Error attempting operation. Transfer timed out."
				set ERROR_RESULT true
			} -re "Sent .\d+" {
				expect -re "(.*?%)"
			} "No such file or directory" {
				set ERROR_MESSAGE "Error attempting operation.  No such file or directory."
				set ERROR_RESULT true
			}							
		} -re "%" {
              send "exit\r"
		  expect -re $exec_prompt
            }		
		} "uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command quit"
			set ERROR_RESULT true
			expect -re $exec_prompt
		} "unknown command" {
			set ERROR_MESSAGE "Error attempting operation.  Bad command or invalid permissions."
			set ERROR_RESULT true
			expect -re $exec_prompt
    	} "Command not found" {
    		set ERROR_MESSAGE "Error attempting operation.  Bad command or invalid permissions."
			set ERROR_RESULT true
    	} -re $exec_prompt {
      }
	}

set timeout $standard_timeout