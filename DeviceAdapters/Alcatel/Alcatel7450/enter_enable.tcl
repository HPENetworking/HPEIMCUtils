
#**************************************************************************
# Identification:enter_exec
# Purpose:       enter the "exec" mode on the device
#**************************************************************************

#send "environment\r\n"
send "\r\n"

set loop true

while {$loop == "true"} {
	expect {
#		-re "environment#" {
#			send "no more\r\n"
#			send "exit\r\n"
		}
		-re $enable_prompt {
			set loop false
		}
	}
}
set IGNORE_DELAY false