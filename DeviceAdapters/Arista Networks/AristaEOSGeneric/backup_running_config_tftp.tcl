
#**************************************************************************
# Identification:backup_running_config_tftp
# Purpose:       backup running configuration by tftp
#**************************************************************************


	set timeout $long_timeout
	set WARNING_RESULT true
	send "copy $runningConfig tftp:\r"
    expect { 
		-re "Unable to (read|get) configuration" {
			set ERROR_MESSAGE "Unable to read configuration. The device may be suffering from a failure."
			set ERROR_RESULT true
			expect $enable_prompt
		} -re "nvalid" {
			set ERROR_MESSAGE "Could not copy the $runningConfig to a tftp server."
			set ERROR_RESULT true
			expect $enable_prompt
		} "uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command copy $runningConfig tftp"
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
				} -re $enable_prompt {
				}
			}
		}
	}
	if { $ERROR_RESULT != "true" } {
		set WARNING_RESULT false
	}
	set timeout $standard_timeout
