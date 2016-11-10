
#**************************************************************************
#Identification: backup_running_config_cli
#Purpose:        backup running configuration by cli.
#**************************************************************************

sleep 1
expect *

set timeout $long_timeout
send "show $runningConfig\r"

set loop true
while {$loop == "true"} {
	expect { 
		-re "$more_prompt" {
			send " "
		} -re "Unable to (read|get) configuration" {
			set ERROR_MESSAGE "Unable to read configuration. The device may be suffering from a failure."
			set ERROR_RESULT true
			expect $enable_prompt
			set loop false
		} "Non-Volatile memory is in use" {
			set ERROR_MESSAGE "The non-volatile memory was busy. A snapshot could not be taken. Please try again."
			set ERROR_RESULT true
			expect $enable_prompt
			set loop false
		} "uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command show $runningConfig"
			set ERROR_RESULT true
			expect $enable_prompt
			set loop false
		} "nvalid inpurt (privileged mode required)" {
			set ERROR_MESSAGE "The user is not authorized to use the command show $runningConfig"
			set ERROR_RESULT true
			expect $enable_prompt
			set loop false
		} -re "Invalid input detected" {
			set ERROR_MESSAGE "Could not show the $runningConfig."
			set ERROR_RESULT true
			expect $enable_prompt
			set loop false
		} -re "$enable_prompt" {
			# Done
			set loop false
		} timeout {
            #set ERROR_MESSAGE "Timeout."
            #set ERROR_RESULT true
            set loop false
		}
	}
}
set timeout $standard_timeout
