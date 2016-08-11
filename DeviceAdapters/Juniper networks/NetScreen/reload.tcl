
#**************************************************************************
# Identification:reload.tcl
# Purpose:       reload device
#**************************************************************************

send "reset\r"
expect {
	-re "Configuration modified, save?" {
		send "y\r"
		expect -re "System reset"
		send "y\r"
	} -re "System reset" {
		send "y\r"
	}
}
close