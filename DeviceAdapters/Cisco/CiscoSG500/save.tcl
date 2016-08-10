
#**************************************************************************
# Identification: save.tcl
# Purpose:        save device configuration
#**************************************************************************
    
    send "commit \r"
   	set loop true
		while {$loop == "true"} {
			  expect -re "Install operation" {
			    set ERROR_MESSAGE "Missing password"
					set ERROR_RESULT true
					set loop false
					expect $enable_prompt
				} -re "y/n" {
					send "y"
				} -re "Do you wish to proceed" {
					send "yes"
				} -re "No configuration changes to commit" {
					expect $enable_prompt
				} -re $enable_prompt {
					set loop false
				}
		}

}
