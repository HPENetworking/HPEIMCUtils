
#**************************************************************************
# Identification:exit_config_terminal
# Purpose:       exit the "config terminal" mode on the device
#**************************************************************************

    send "\r"
    expect {
        $config_prompt {
            set loop true
            while { $loop == "true" } {
                send "exit\r"
                expect {
                    "Uncommitted changes found, commit them before exiting(yes/no/cancel)?" {
                        if {$ERROR_RESULT == "true"} {
                            send "no\r"
                        } else {
                            send "yes\r"
                        }
                        expect $enable_prompt
                        set loop false
                    } -re $config_prompt {

                    } -re $enable_prompt {
                        set loop false
                    } $orig_enable_prompt {
						set loop false
						if {$useTruePrompt != "false"} {
							send "\r"
							expect -re "(.*?$orig_enable_prompt)"
							set enable_prompt $expect_out(1,string)
						}
					}
                }
            }
        } -re $enable_prompt {
        }
    }
    if {$enforce_save == "true"} {
        save
    }
    