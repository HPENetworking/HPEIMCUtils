
#**************************************************************************
# Identification:enter_enable
# Purpose:       enter the "enable" mode on the device
#**************************************************************************
     
    if {$use_securid == "enable"} {
        set enable_password $securid_enable_passcode
        set enable_next_passcode $securid_enable_next_passcode
    }
    # If the user can't login to enable, try to succeed without it 
    if { $execAccessOnly == "true" } {
        set enable_prompt $exec_prompt
    } else {        
        send "enable\r"
        set loop true
        while {$loop == "true"} {
            expect {
                -re $password_prompt {
                    if {$enable_password == "\x24enable_password" || $enable_password == ""} {
                        set ERROR_MESSAGE "Missing enable password"
                        set ERROR_RESULT true
                        set loop false
                    } else {
                        send "$enable_password\r"
                    }
                } "Last login:" {
                # Nothing... deliberately ignore so the username_prompt
                # doesn't pick this one up

                # As seen with bug 6462; use base username as enable-username 
                } -re $username_prompt {
                    if {$username == "\x24username" || $username == ""} {
                        set ERROR_MESSAGE "Missing username (used at enable level)"
                        set ERROR_RESULT true
                        return
                    } else {                        
                        send "$username\r"
                        expect -re $enable_password_prompt
                        send "$enable_password\r"
                    }
                } -re $enable_prompt {
                   set loop false
                } -re "Access \[Dd\]enied" {
                    set ERROR_MESSAGE "Enable access denied"
                    set ERROR_RESULT true
                    set loop false
                } "Bad secret" {
                    set ERROR_MESSAGE "Bad enable secret"
                    set ERROR_RESULT true
                    set loop false
                } "Bad password" {
                    set ERROR_MESSAGE "Bad enable password"
                    set ERROR_RESULT true
                    set loop false
                } "Error in authentication" {
                    set ERROR_MESSAGE "Error in authentication"
                    set ERROR_RESULT true
                    set loop false
                } "Authorization failed" {
                    set ERROR_MESSAGE "Admin privileges required to enter enable mode"
                    set ERROR_RESULT true
                    set loop false
                } "Invalid command" {
                    set loop false
                } -re "monitor: command .* not found" {
                    set ERROR_MESSAGE "The device appears to be in monitor mode."
                    set ERROR_RESULT true
                    set loop false
                } -re $suspect_prompt {
                    set loop false
                    set enable_prompt $suspect_prompt
                } 
            }
        }
        # Try to recover a prompt, then return 
        if { $ERROR_RESULT == "true" } {
            return
        }
        if {$useTruePrompt != "false"} {
            send "\r"
            expect -re "\[\r\n\]+(.*?$enable_prompt)"
            set enable_prompt $expect_out(1,string)
        }
    } 
    