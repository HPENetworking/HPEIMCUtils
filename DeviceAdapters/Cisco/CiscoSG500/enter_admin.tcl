#**************************************************************************
# Identification:enter_admin
# Purpose:       enter the "admin" mode on the device
#**************************************************************************

	send "admin\r"
	
	set loop true
	
	while ($loop == "true") {
		expect {
			-re $error_pattern {
				set ERROR_MESSAGE "Incomplete/Unknown/Unrecognized/Too many parameters/Invalid/.*uthorization failed"
                set ERROR_RESULT true
				expect $enable_prompt
				set loop false
			} -re $admin_prompt {
				set loop false
			}
		}
	}