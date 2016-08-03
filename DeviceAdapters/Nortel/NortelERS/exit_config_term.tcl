
#**************************************************************************
# Identification:exit_config_term
# Purpose:       exit the "config_term" mode on the device
#**************************************************************************

send "end\r"
expect $enable_prompt
if {$enforce_save == "true"} {
	save
}