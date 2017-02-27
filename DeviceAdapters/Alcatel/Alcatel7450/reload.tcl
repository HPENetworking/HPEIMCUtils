#**************************************************************************
# Identification:reload.tcl
# Purpose:       reload device
#**************************************************************************

	if {$enforce_save == "true"} {
		save
	}
	
	send "admin reboot now\r\n"
	close