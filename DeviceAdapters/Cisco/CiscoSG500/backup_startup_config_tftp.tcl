
#**************************************************************************
# Identification:backup_startup_config_tftp
# Purpose:       backup startup configuration by tftp
#**************************************************************************


			set timeout $very_long_timeout
			set WARNING_RESULT true
			send "copy $startupConfig tftp://$TFTPServer/$TFTPFile\r"
            expect { 
				"Unable to read configuration" {
					set ERROR_MESSAGE "Unable to read configuration. The device may be suffering from a failure."
					set ERROR_RESULT true
					expect $enable_prompt
				} -re "% Invalid" {
					set ERROR_MESSAGE "Could not copy the $runningConfig to a tftp server."
					set ERROR_RESULT true
					expect $enable_prompt
				} -re "(This command is not authorized|Command authorization failed)" {
					set ERROR_MESSAGE "The user is not authorized to use the command copy $runningConfig tftp"
					set ERROR_LOGIN true
					expect $enable_prompt
				} -re $enable_prompt {
					send "\r"
					expect -re $enable_prompt
				}
			}
			if { $ERROR_RESULT != "true" } {
				set WARNING_RESULT false
			}
			set timeout $standard_timeout
	