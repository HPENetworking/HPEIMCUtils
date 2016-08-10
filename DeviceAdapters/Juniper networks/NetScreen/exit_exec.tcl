
#**************************************************************************
# Identification:exit_exec
# Purpose:       quit the "exec" mode on the device
#**************************************************************************

send "exit\r"
expect {
	 -re "Configuration modified, save?" {
		send "y\r"
	} -re "closed" {
		# May receive this from a bastion host connection
	} timeout {
	}
}