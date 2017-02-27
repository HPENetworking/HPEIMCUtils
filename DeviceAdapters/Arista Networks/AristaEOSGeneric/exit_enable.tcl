
#**************************************************************************
# Identification:exit_enable
# Purpose:       exit the "enable" mode on the device
#**************************************************************************

    if {$enforce_save == "true"} {
        save
    }
    send "disable\r"
    expect {
        $exec_prompt {
        } $orig_exec_prompt {
            if {$useTruePrompt != "false"} {
                send "\r"
                expect -re "(.*?$orig_exec_prompt)"
                set exec_prompt $expect_out(1,string)
            }
        }
    }
    