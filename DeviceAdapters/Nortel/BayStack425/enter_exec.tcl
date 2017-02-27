
#**************************************************************************
# Identification:enter_exec
# Purpose:       enter the "exec" mode on the device
# Warning : Last charachter in a Nortel consol is not * but "\u001b"
#**************************************************************************

    set IGNORE_DELAY true
    set sent_CtrlY false
    set loop true
    while {$loop == "true"} {
        expect {
            -re "(Invalid input detected|Ambiguous command)" {
                set ERROR_MESSAGE "Invalid or Ambiguous command."
                set ERROR_RESULT true
                set loop false
            } -re "Incorrect Password" {
                set ERROR_MESSAGE "Incorrect Password."
                set ERROR_RESULT true
                set loop false
                return
            } -re $initial_prompt {
                if { $sent_CtrlY != "true" } {
				    send "\x19"
					set sent_CtrlY true
					} else {
					# Already sent CtrlY... don't send again
					expect "*"
				}
            } -re $password_prompt {                
                send "$password\r"
				send "\x12"
				} -re "(Incorrect Credentials|Incorrect Password|Access Denied)" {
                set ERROR_MESSAGE "Access denied by the device"
                set ERROR_RESULT true
                set loop false
                return 
            } -re $username_prompt {
                 send "$username\r"
			 } -re "no response from RADIUS" {
				set ERROR_MESSAGE "The device could not authenticate through the RADIUS server. Connection timed out."
				set ERROR_RESULT true
				set loop false
                return
			} -re "(Main Menu|Use arrow keys to highlight|ommand Line Interface)" {
			    # Make sure we're past the menu entirely
				#set ERROR_MESSAGE "Je suis dans le main menu"
				expect "to select option"
				expect "\u001b"
				# Get to the command prompt 
				send "C"
				#send "\r"
			} $menuPrompt {
                if { $sent_menuExit == "true" } {
                    set ERROR_MESSAGE "The menuExit variable may be incorrect: sent $menuExit"
                    set ERROR_RESULT true
                    return
                }
                send "$menuExit\r"
                expect "\u001b"
                set sent_menuExit true
            } $exec_prompt {
                send "\r"
                expect $exec_prompt
                set loop false
            } $enable_prompt {
                if { $forceDisable == "true" } {
                    send "disable\r"
                    expect $exec_prompt
                }
                if { $forceDisable != "true" } {
                    set exec_prompt $enable_prompt
                }
                set loop false
            } 
        }
    }
   
    set IGNORE_DELAY false
