
#**************************************************************************
# Identification:backup_startup_config_cli
# Purpose:       backup startup configuration by cli
#**************************************************************************

set timeout $long_timeout
send "show configuration\r"
expect { 
	"Unable to read configuration" {
		set ERROR_MESSAGE "Unable to read configuration. The device may be suffering from a failure."
		set ERROR_RESULT true
		expect $exec_prompt
	} "uthorization failed" {
		set ERROR_MESSAGE "The user is not authorized to use the command show running"
		set ERROR_RESULT true
		expect $exec_prompt
	} "syntax error" {
		set ERROR_MESSAGE "Could not run command: show configuration"
		set ERROR_RESULT true
	} -re $exec_prompt {
	}
}
set timeout $standard_timeout