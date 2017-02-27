
#**************************************************************************
# Identification: save.tcl
# Purpose:        save device configuration
#**************************************************************************
proc save {} {
    global exec_prompt 
    global enable_prompt
    global standard_timeout 
    global long_timeout
    set timeout $long_timeout
    
    send "write memory\r"
    expect {
        "Overwrite the previous NVRAM configuration" {
            send "\r"
            expect $enable_prompt
        } -re "Warning: (.*)" {
            set error $expect_out(1,string)
            set ERROR_MESSAGE "Check the device. The configuration may be in jeopardy: $error"
            set ERROR_RESULT true
            send "\r"
            expect $enable_prompt
        } -re $enable_prompt {
        }
    }
    set timeout $standard_timeout
}
