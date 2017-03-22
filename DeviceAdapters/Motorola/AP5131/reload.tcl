#**************************************************************************
# Identification:reload.tcl
# Purpose:       reload device
#**************************************************************************

send "system\r\r"
expect { 
    -re ".*" {
		sleep 1
        send "restart\r" 
        expect {
			-re ".*" {
			sleep 1
			send -s "yes\r\n"
			}
		}
    }  $enable_prompt {
    }
}	
	
close