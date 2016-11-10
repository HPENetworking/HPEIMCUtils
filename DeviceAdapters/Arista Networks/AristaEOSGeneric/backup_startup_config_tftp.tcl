
#**************************************************************************
# Identification:backup_startup_config_tftp
# Purpose:       backup startup configuration by tftp
#**************************************************************************


	set timeout $long_timeout
	set WARNING_RESULT true
	send "copy $startupConfig tftp:\r"
    expect { 
		-re "Non-volatile configuration memory (.*)" {
			set error $expect_out(1,string)
	     	set ERROR_MESSAGE "Non-volatile configuration memory $error."
			set ERROR_RESULT true
			expect $enable_prompt
		} -re "nvalid" {
			set ERROR_MESSAGE "Could not copy the startup-configuration."
			set ERROR_RESULT true
			expect $enable_prompt
		} "uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command copy startup-config tftp"
			set ERROR_RESULT true
			expect $enable_prompt
		} "\\?" {
	  	    send "$TFTPServer\r"
		    expect "\\?"
    		send "$TFTPFile\r"
    		expect {
				"bytes copied" {
					expect $enable_prompt
				} "Error opening" {
					set ERROR_MESSAGE "An error occurred with the TFTP server at address $TFTPServer"
					set ERROR_RESULT true
					expect $enable_prompt
				} "Error writing" {
					set ERROR_MESSAGE "An error occurred writing the TFTP file to the TFTP server at address $TFTPServer"
				   	set ERROR_RESULT true
					expect $enable_prompt
				} "\\?" {
					send "\r"
					expect "bytes copied"
					expect $enable_prompt
				} $enable_prompt {
					set ERROR_MESSAGE "Could not copy the startup configuration. The flash may have been erased. The device configuration may need to be synchronized by writting memory."
					set ERROR_RESULT true
				}
			}
		}
	}
	if { $ERROR_RESULT != "true" } {
		set WARNING_RESULT false
	}
	set timeout $standard_timeout
	