            
#**************************************************************************
# Identification:cleanup.tcl
# Purpose:       try to recover a prompt, then exit
#**************************************************************************

proc cleanup {} {
    global ERROR_RESULT
    global exec_prompt
    global config_prompt	

    if { $ERROR_RESULT == "true" } {
        set loop true
        while { $loop == "true" } {
            send "\r"
            expect {
                -re $exec_prompt {
                    send "logout\r"
                    set loop false
                } -re $config_prompt {
                    send "exit\r"
                    expect $exec_prompt
                } -re "(Bad|denied)" {
                    send "\r"
                    expect $exec_prompt
                }
            }
        }
    }
}
