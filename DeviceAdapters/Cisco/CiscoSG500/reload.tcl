
#**************************************************************************
# Identification:reload.tcl
# Purpose:       reload device
#**************************************************************************

	send "reload\r"
	
	set loop true
	
	while($loop == "true") {
		expect {
			-re "save ?" {
				send "no\r"
				except "?"
			} -re "?" {
				send " "
				except "confirm"
			} -re "confirm" {
		  	    send " "
		  	    set loop false
			} -re "The connection is no longer available." {
				set loop false
				return
			} -re "undefined" {
				set ERROR_MESSAGE "Incomplete command"
				set ERROR_RESULT true
				set loop false
				expect $enable_prompt
			} -re "reboot_timeout" {
				set ERROR_MESSAGE "Incomplete command"
				set ERROR_RESULT true
				set loop false
				expect $enable_prompt
			}
		}
	}
	
	