
#**************************************************************************
# Identification:enter_exec
# Purpose:       enter the "exec" mode on the device
#**************************************************************************

set IGNORE_DELAY true
if {$banner_skip_repeat != "0"} {
	expect -re "$banner_skip"
	expect "*"
}

set loop true
while {$loop == "true"} {
	expect {
		"Last login:" {
			expect $exec_prompt
			send "\r"
			expect $exec_prompt
			set loop false
		} -re $password_prompt {
			if {$password == "\x24password" || $password == ""} {
				set ERROR_MESSAGE "Missing password"
				set ERROR_RESULT true
				return
			} else {
				send "$password\r"
				set sent_password "true"
			}
		} -re $next_passcode_prompt {
			if { $use_securid != "exec" && $use_securid != "enable" } {
				set ERROR_MESSAGE "Device not configured for SecurID."
				set ERROR_LOGIN true
				return
			}
			send "$next_passcode\r"
		} $username_prompt {
			if { $use_securid != "\x24use_securid" && $sent_password == "true" } {				
				set ERROR_MESSAGE "SecurID authentication failed."
				set ERROR_LOGIN true
				return
			} else {

				if {$username == "\x24username" || $username == ""} {
					set ERROR_MESSAGE "Missing username"
					set ERROR_RESULT true
					return
				} else {
					send "$username\r"
					set sent_password "false"
				}
			}
		} "new tokencode:" {
			send "$next_passcode\r"
		} "Enter a new PIN" {
			set ERROR_MESSAGE "Could not login. A new pin needs to be created for this Secure ID user."
			set ERROR_RESULT true
			return
		} "error: Unable to authenticate" {
			set ERROR_MESSAGE "Super-user account is required for device management."
			set ERROR_RESULT true
			return
		} "Press Y or ENTER to continue, N to exit" {
			send "Y"			
		} "Wrong password" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Wrong password."
			#exit
			set loop false
		} "Please press ENTER" {
			send "\r"
			set loop false
		} "Login failed" {
			# Failure ... get out
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Device rejected the username or password."
			#exit			
			set loop false
		} "Passphrase for key" {
			send "$passphrase\r"
		} -re "y/n" {
			send "y\r"
		} -re "Store key in cache|Update cached key" {
			send "y\r"
		} "Unable to use key file" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Unable to use key file."
			set loop false
		} "Network error" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Network error."
			set loop false
		} "Access denied" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Access denied."
			set loop false
		} "Authentication refused" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Authentication refused."
			set loop false
		} "FATAL ERROR:" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "FATAL ERROR."
			set loop false
		} "Fatal:" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "FATAL."
			set loop false
		} "Unable to load private key" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Unable to load private key."
			set loop false
		} "Server refused" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Server refused."
			set loop false
		} "Enter passphrase for key" {
			send "$passphrase\r"
		} "Are you sure you want to continue connecting" {
			send "yes\r"
		} "Permission denied" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Permission denied."
			set loop false
		} "Received disconnect" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Received disconnect."
			set loop false
		} "bad permissions" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "bad permissions."
			set loop false
		} "Identity file * not accessible:" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Identity file not accessible."
			set loop false
		} "Connection refused" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Connection refused."
			set loop false
		} "Connection timed out" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Connection timed out."
			set loop false
		} "connection is closed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "connection is closed."
			set loop false
		} "Connection closed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Connection closed."
			set loop false
		} "Write failed:" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Write failed: Broken pipe."
			set loop false
		} "Missing argument" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Missing argument."
			set loop false
		} "no authentication methods available" {
		#Bitvise
			set ERROR_RESULT  true
			set ERROR_MESSAGE "no authentication methods available."
			set loop false
		} "Authentication failed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Authentication failed."
			set loop false
		} "S/A/C" {
			send "S\r"
		} "assphrase:" {
			send "$passphrase\r"
		} "Too many authentication failures" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Too many authentication failures."
			set loop false
		} "Connection aborted" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Connection aborted."
			set loop false
		} "parameter failed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "parameter failed."
			set loop false
		} "Connection failed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Connection failed."
			set loop false
		} "passphrase is invalid" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "passphrase is invalid."
			set loop false
		} "Server rejected" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Server rejected."
			set loop false
		} -re $shell_prompt {
			send "cli\r"
			expect -re $exec_prompt
			send "\r"
			expect -re $exec_prompt
			set loop false
		} "Authentication failed" {
			set ERROR_MESSAGE "Authentication failed"
			set ERROR_RESULT true
			return
		} "Login incorrect" {
			set ERROR_MESSAGE "Login incorrect"
			set ERROR_RESULT true
			return
		}
	}
}
if {$useTruePrompt != "false" } {
	send "\r"
	expect -re "(.*?$exec_prompt)"
	set exec_prompt $expect_out(1,string)
}
if {$resetMorePrompting != "false"} {
	send "set cli screen-length 0\r"
	expect $exec_prompt
}
set IGNORE_DELAY false