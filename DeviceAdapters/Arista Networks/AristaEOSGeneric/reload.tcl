
#**************************************************************************
# Identification:reload
# Purpose:       reload
#**************************************************************************


	if {$enforce_save == "true"} {
		save
	}
	
	send "reload\r"
	expect {
		"Save?" {
			send "no\r"
			expect { 
				"\\?" {
				} "confirm" {
				}
			}
		} "uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command reload"
			set ERROR_RESULT true
			expect $enable_prompt
		} "\\?" {
		} "confirm" {
		   send " "
		}
	}
	
	send "\r"
	sleep 10
	close
	