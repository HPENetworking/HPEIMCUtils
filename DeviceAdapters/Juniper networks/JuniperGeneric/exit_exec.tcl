
#**************************************************************************
# Identification:exit_exec
# Purpose:       quit the "exec" mode on the device
#**************************************************************************

if {$enforce_save == "true"} {
	send "configure\r"
	expect { 
		"unknown command" {
			set ERROR_MESSAGE "Could not save the configuration. The configure command was not accepted by the device."
			set ERROR_RESULT true
			expect $exec_prompt
		} $config_prompt {
			send "commit\r"
			expect $config_prompt
			send "exit\r"
			expect {
				"Exit with uncommitted changes" {
					# Commit may have failed,.. but exit anyways
					send "yes\r"
					expect $exec_prompt
				} $exec_prompt {
					# Success
				}
			}							
		}
	}
}

send "exit\r"