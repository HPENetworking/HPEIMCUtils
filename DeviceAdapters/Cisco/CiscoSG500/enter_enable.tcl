

#**************************************************************************
# Identification:enter_exec
# Purpose:       enter the "exec" mode on the device
#**************************************************************************

    set IGNORE_DELAY true
#    if { $use_undeterministic_prompt == "true" } {
        set undeterministic_prompt $tc_undeterministic_prompt
#    } 

    if {$banner_skip_repeat != "0"} {
        expect -re "$banner_skip"
        expect "*"
    }
    set loop true
    while {$loop == "true"} {
        expect {
            -re $password_prompt {                
                send "$password\r"
                set sent_password "true"
                if { $use_undeterministic_prompt == "true" } {
                    sleep 1
                }
            } -re $next_passcode_prompt {
                if { $use_securid != "enable" } {
                    set ERROR_MESSAGE "Device not configured for SecurID."
                    set ERROR_LOGIN true
                    return
                }
                send "$next_passcode\r"
            } "Last login:" {
                # Nothing... deliberately ignore so the username_prompt
                # doesn't pick this one up
                expect "*"
            } -re $username_prompt {
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
            } $menuPrompt {
                if { $sent_menuExit == "true" } {
                    set ERROR_MESSAGE "The menuExit variable may be incorrect: sent $menuExit"
                    set ERROR_RESULT true
                    return
                }
                send "$menuExit\r"
                expect "*"
                set sent_menuExit true
            } -re "(monitor: command)" {
                set ERROR_MESSAGE "The device appears to be in monitor mode."
                set ERROR_RESULT true
                set loop false
            } -re $enable_prompt {
				send "\r"
				expect -re $enable_prompt
                set loop false
            } "Enter a new PIN" {
                set ERROR_MESSAGE "Could not login. A new pin needs to be created for this Secure ID user."
                set ERROR_RESULT true
                return
            } "Access Denied" { 
                set ERROR_MESSAGE "Access denied by the device"
                set ERROR_RESULT true
                return
            } "Authentication failed" {
                set ERROR_MESSAGE "Authentication failed"
                set ERROR_RESULT true
                return
            } "Login invalid" {
                set ERROR_MESSAGE "Login invalid"
                set ERROR_RESULT true
                return
            } "Bad password" {
                set ERROR_MESSAGE "Bad password"
                set ERROR_RESULT true
                return
    		} "Passphrase for key" {
    			send "$passphrase\r"
    		} -re "y/n" {
    			send "y\r"
    		} -re "Store key in cache|Update cached key" {
    			send "y\r"
    		} "Unable to use key file" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Unable to use key file."
                return
    		} "Network error" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Network error."
                return
    		} "Access denied" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Access denied."
                return
    		} "Authentication refused" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Authentication refused."
                return
    		} "FATAL ERROR:" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "FATAL ERROR."
                return
    		} "Fatal:" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "FATAL."
                return
    		} "Unable to load private key" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Unable to load private key."
                return
    		} "Server refused" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Server refused."
                return
    		} "Enter passphrase for key" {
    			send "$passphrase\r"
    		} "Are you sure you want to continue connecting" {
    			send "yes\r"
    		} "Permission denied" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Permission denied."
                return
    		} "Received disconnect" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Received disconnect."
                return
    		} "bad permissions" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "bad permissions."
                return
    		} "Identity file * not accessible:" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Identity file not accessible."
                return
    		} "Connection refused" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Connection refused."
                return
    		} "Connection timed out" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Connection timed out."
                return
    		} "connection is closed" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "connection is closed."
                return
    		} "Connection closed" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Connection closed."
                return
    		} "Write failed:" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Write failed: Broken pipe."
                return
    		} "Missing argument" {
    			set ERROR_RESULT  true
    			set ERROR_MESSAGE "Missing argument."
                return
            } "% A decimal" {
                set ERROR_MESSAGE "A menu was detected but the exit command was incorrect."
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
        send "terminal length 0\r"
        expect {
            -re "monitor: command .* not found" {
                set ERROR_MESSAGE "The device appears to be in monitor mode."
                set ERROR_RESULT true
                expect $exec_prompt
            } $exec_prompt {
            }
        }
    }
    set IGNORE_DELAY false
