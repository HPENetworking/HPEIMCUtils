
#**************************************************************************
# Identification:enter_config_term
# Purpose:       enter the "config term" mode on the device
#**************************************************************************

send "configure\r"
expect {
	"unknown command" {
		set ERROR_MESSAGE "Could not utilize the configure command on this device."
		set ERROR_RESULT true
		expect $exec_prompt
	} "Users currently editing" {
		# Look for a config prompt that _starts_ the line [there are two here]
		expect -re "edit]"					
	} -re $config_prompt {
	    expect $enable_prompt
	}
}