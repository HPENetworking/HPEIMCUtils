
#**************************************************************************
# Identification:backup_startup_config_cli
# Purpose:       backup startup configuration by cli
#**************************************************************************

sleep 1
expect *

set timeout $long_timeout
send "show $startupConfig\r"

set loop true
while {$loop == "true"} {
	expect {
		-re "$more_prompt" {
			send " "
		} -re "Non-volatile configuration memory (.*)" {
			set error $expect_out(1,string)
			set ERROR_MESSAGE "Non-volatile configuration memory $error"
			set ERROR_RESULT true
			expect $enable_prompt
			set loop false
		} "startup-config is not present" {
	     	set ERROR_MESSAGE "startup-config is not present."
			set ERROR_RESULT true
			expect $enable_prompt			
			set loop false
		} "uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command show $startupConfig"
			set ERROR_RESULT true
			expect $enable_prompt
			set loop false
		} -re "Invalid input detected" {
			set ERROR_MESSAGE "Could not show the startup-configuration (show $startupConfig)."
			set ERROR_RESULT true
			expect $enable_prompt
			set loop false
		} -re "Error opening" {
			set ERROR_MESSAGE "An error occurred wile opening file $startupConfig"
			set ERROR_RESULT true
			set loop false
			expect $enable_prompt
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
