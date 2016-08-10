
#**************************************************************************
# Identification:enter_exec
# Purpose:       enter the "exec" mode on the device
#**************************************************************************

set IGNORE_DELAY true
set loop true
set sent_password false
while {$loop == "true"} {
	expect { 
		"Store key in cache? (y/n)" {
			send "y\r"
		} -re $password_prompt {
			if {$sent_password == "true"} {
				set ERROR_MESSAGE "Incorrect password"
				set ERROR_RESULT true
				exit
			}
			send "$password\r"
			set sent_password true
		} -re $username_prompt {
			send "$username\r"
		} -re "Accept this agreement" {
			send "y\r"
		} -re $exec_prompt {
			send "\r"
			expect -re $exec_prompt
			set loop false
		} -re "failed" {
			set ERROR_MESSAGE "Login failed"
			set ERROR_RESULT true
			exit
		}
	}
}			
set IGNORE_DELAY true