
#**************************************************************************
# Identification:deploy_running_config_cli
# Purpose:       deploy running configuration by cli
#**************************************************************************

set timeout $very_long_timeout
set WARNING_RESULT true
send "load replace rn_config\r"

expect {
	-re "\\d+ errors" {
		set ERROR_MESSAGE "Could not merge the configuration due to errors in the deployed configuration."
		set ERROR_RESULT true
	} -re "error: (.*)" {
		set ERROR_MESSAGE "Could not load configuration."
		set ERROR_RESULT true
	} "load complete" {
	}
}
expect $config_prompt

if { $ERROR_RESULT != "true" } {
	set WARNING_RESULT false
}
set timeout $standard_timeout