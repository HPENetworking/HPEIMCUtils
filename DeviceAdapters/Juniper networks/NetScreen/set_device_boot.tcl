
#**************************************************************************
# Identification:set_device_boot.tcl
# Purpose:       set the device next startup image by cli
#**************************************************************************

send "reset\r"
expect {
		 -re "are you sure?" {
			send "\r"
			expect -re "reset" {
			}
	}
}
return