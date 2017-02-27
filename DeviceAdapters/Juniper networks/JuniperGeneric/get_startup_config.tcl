
#**************************************************************************
# Identification:get_startup_config.tcl
# Purpose:       get startup configuration file name by cli
#**************************************************************************


# Display startup returns the name of the startup configuration file
send "display startup\r"
set loop true

while {$loop == "true"} {
	expect {
		-re $more_prompt {
			send " "
		} -re "\n.+$error_pattern" {
    		set error_message $expect_out(1,string)
			expect -re $exec_prompt
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Device error: $error_message"
			set loop false
		} -re $exec_prompt {
			# Done
			set loop false
		}		
	}		
}