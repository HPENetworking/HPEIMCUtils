
#**************************************************************************
#Identification: prepare_startup_config_cli
#Purpose:        prepare startup config by cli.
#**************************************************************************

set timeout $long_timeout
send "show configuration | no-more | save $config_filename\r"
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
	} "lines of output to" {
		# Warning: sometimes device re-echoes the prompt because of a line wrap... look for
		# the actual 'save' message to exit properly without truncating the configuration.

		# Success -- wrote so-and-so many lines
		expect $exec_prompt
	}
}
set timeout $standard_timeout
	