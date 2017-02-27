
#**************************************************************************
# Identification:exit_enable
# Purpose:       exit the "enable" mode on the device
#**************************************************************************

if {$enforce_save == "true"} {
	save
}
send "disable\r"
expect $exec_prompt