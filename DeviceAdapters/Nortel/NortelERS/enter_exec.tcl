
#**************************************************************************
# Identification:enter_exec
# Purpose:       enter the "exec" mode on the device
#**************************************************************************

set IGNORE_DELAY true

set loop true
while {$loop == "true"} {
	expect {						

		"Ctrl-Y" {
			send "\x19"
		} "Last Telnet session is being cleaned up" {
			set ERROR_RESULT true
			set ERROR_MESSAGE "Device reports that the last session is being cleaned up. Please try again."
			return
		} "Incorrect" {
			set ERROR_MESSAGE "Authentication failed"
			set ERROR_RESULT true
			return
		}						
		$password_prompt {
			if {$password == "\x24password" || $password == ""} {
				set ERROR_MESSAGE "Missing password"
				set ERROR_RESULT true
				return
			} else {
				if {$sent_password == "false"} {
					# Use admin password, not limited 'exec' password
					send "$password\r"
					set sent_password "true"
				}

				expect "*"
			}
		} $username_prompt {
			if {$username == "\x24username" || $username == ""} {
				set ERROR_MESSAGE "Missing username"
				set ERROR_RESULT true
				return
			} else {
				send "$username\r"
				set sent_password "false"
			}
		} $exec_prompt {
			send "\r"
			expect $exec_prompt
			set loop false
		} $enable_prompt {
			send "disable\r"
			expect $exec_prompt
			set loop false
		}					
	}
}
if {$useTruePrompt != "false" } {
	send "\r"
	expect -re "(.*?$exec_prompt)"
	set exec_prompt $expect_out(1,string)
}
set IGNORE_DELAY false