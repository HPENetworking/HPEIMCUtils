#**************************************************************************
# Identification:enter_enable
# Purpose:       enter the "enable" mode on the device
#**************************************************************************

expect "*"
sleep 1
send "\r\r"

set loop true
while {$loop == "true"} {
	expect {
		 -re $enable_prompt {
			set loop false
		} -re "Access denied" {
			set ERROR_MESSAGE "Enable access denied"
			set ERROR_RESULT true
			set loop false
		} -re "% Incorrect Password" {
			set ERROR_MESSAGE "Bad enable secret"
			set ERROR_RESULT true
			set loop false
		} 
	}
}

expect "*"
