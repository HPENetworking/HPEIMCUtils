
#**************************************************************************
# Identification:deploy_startup_config_tftp
# Purpose:       deploy startup configuration by tftp
#**************************************************************************

	set timeout $long_timeout
	send "copy tftp://$TFTPServer/$TFTPFile startup-config\r"
	expect {
		"uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command copy tftp startup-config"
			set ERROR_RESULT true
			expect -re $enable_prompt
		} "\\?" {
			send "\r"
			expect {
				"no]:" {
					send "yes\r"
					expect "bytes copied"
					expect -re $enable_prompt
                } "Error opening" {
                    set ERROR_RESULT true
                    set ERROR_MESSAGE "Could not copy the configuration from the server $TFTPServer"
				} "bytes copied" {
					expect -re $enable_prompt
				}
			}
		}
	}
	set timeout $standard_timeout
	