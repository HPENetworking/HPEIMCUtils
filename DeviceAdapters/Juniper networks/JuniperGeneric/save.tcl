
#**************************************************************************
# Identification: save.tcl
# Purpose:        save device configuration
#                 don't support
#**************************************************************************
proc save {} {
      global config_prompt 
      global exec_prompt 
      global ERROR_MESSAGE
      global ERROR_RESULT
      global enable_prompt
      
	send "commit\r"
	expect { 
		-re "warning: (.*)" {
			set error $expect_out(1,string)
			set ERROR_MESSAGE "Could not commit configuration: $error"
			set ERROR_RESULT true
		} -re "error: (.*)" {
			set error $expect_out(1,string)
			set ERROR_MESSAGE "Could not commit configuration: $error"
			set ERROR_RESULT true
		} "commit complete" {
		}
	}
	expect $config_prompt
    expect $enable_prompt

	if { $ERROR_RESULT != "true" } {
		send "save configuration\r"
		expect { 
			-re "warning: (.*)" {
				set error $expect_out(1,string)
				set ERROR_MESSAGE "Could not save configuration: $error"
				set ERROR_RESULT true
				expect $config_prompt
			} -re "error: (.*)" {
				set error $expect_out(1,string)
				set ERROR_MESSAGE "Could not save configuration: $error"
				set ERROR_RESULT true
				expect $config_prompt
			} $config_prompt {
                expect $enable_prompt
			}	     
	     }
    }
}