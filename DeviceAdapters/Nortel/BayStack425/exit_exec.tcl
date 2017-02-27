
#**************************************************************************
# Identification:exit_exec
# Purpose:       quit the "exec" mode on the device
#**************************************************************************    
    send "logout\r"
	expect {
	    -re "(Main Menu|Use arrow keys to highlight)" {
		    send "l\r"
		} "logout" {
		    
		}
	}
