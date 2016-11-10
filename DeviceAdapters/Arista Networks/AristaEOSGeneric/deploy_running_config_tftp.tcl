
#**************************************************************************
# Identification:deploy_running_config_tftp
# Purpose:       deploy running configuration by tftp
#**************************************************************************

	set timeout $long_timeout
	set WARNING_RESULT true
	send "copy tftp://$TFTPServer/$TFTPFile running-config\r"
    expect {
		"uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command copy tftp running-config"
			set ERROR_RESULT true
			expect $enable_prompt
		} "\\?" {
            send "\r"
			expect {
				"Invalid" {
					set ERROR_RESULT true
					set ERROR_MESSAGE "Invalid commands within the configuration"
                } "Error opening" {
                    set ERROR_RESULT true
                    set ERROR_MESSAGE "Could not copy the configuration from the server $TFTPServer"
                } "Ambiguous command" {
                    set ERROR_RESULT true
                    set ERROR_MESSAGE "Ambiguous commands found within the configuration"
                } "Incomplete command" {
                    set ERROR_RESULT true
                    set ERROR_MESSAGE "Incomplete commands found within the configuration"
                } "ontinue]:" {
                    send "continue\r"
        			expect "bytes copied" 
				} "bytes copied" {
				}
			}
		}
	}

    expect {
		-re $enable_prompt {
		} $orig_enable_prompt {
			if {$useTruePrompt != "false"} {
				send "\r"
				expect -re "\[\r\n\]+(.*?$orig_enable_prompt)"
				set enable_prompt $expect_out(1,string)
			}
		}
	}
	
    set timeout $standard_timeout
    