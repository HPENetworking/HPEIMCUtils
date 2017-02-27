
#**************************************************************************
# Identification:get_startup_config.tcl
# Purpose:       get startup configuration file name by cli
#**************************************************************************

# need do notihing

send "pwd\r"
set loop true
while {$loop == "true"} {
	expect {
		-re $more_prompt {
			send " "
		} -re "uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command show version"
			set ERROR_RESULT true
			expect $enable_prompt
		} -re $enable_prompt {
			# Done
			set loop false
		}		
	}		
}	