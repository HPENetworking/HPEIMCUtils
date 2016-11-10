
#**************************************************************************
# Identification:getversion
# Purpose:       getversion
#**************************************************************************

	send "show version\r"
	expect {
		"uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command show version"
			set ERROR_RESULT true
			expect $enable_prompt
		} -re $enable_prompt {
		}
	}
	