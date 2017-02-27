
#**************************************************************************
# Identification:set_device_boot.tcl
# Purpose:       set device boot software
#**************************************************************************
    
if { $isStack == "YES" } {
    send "boot system switch all $slot$TFTPFile\r"
    expect {
        -re "% Invalid input" {
            set ERROR_MESSAGE "Invalid input detected"
			set ERROR_RESULT true
			expect $config_prompt
        } -re $config_prompt{
            #success
        }
    }
}

if { $isStack == "NO" } {
	set WARNING_RESULT true
	if { $slot == "bootflash:" } {
        if { $bootvalue == "true" } {
            if { $setBootImage == "true" } {
			    send "no boot bootldr\r"
			    expect $config_prompt
    		    send "boot bootldr $slot$TFTPFile\r"
            }
        } else {
            if { $setOSImage == "true" } {
    			if {$isC3750 == "true" || $isC3560 == "true"} {
					if {$tarAutoExtracted != "true"} {
						if {$isC3750 == "true"} {
							send "boot system switch all $slot$TFTPFile\r"
						} else {
							send "boot system $slot$TFTPFile\r"
						}
					} else {
						send "\r"
					}
				} else {
                	send "boot system flash $slot$TFTPFile\r"
				}
            }
        }
		expect {
			"not found" {
				set ERROR_MESSAGE "Could not set the bootldr to $slot$TFTPFile"
				set ERROR_RESULT true
				expect $config_prompt
			} -re $config_prompt {
			}
		}
	}

	if { $slot != "bootflash:" } {
        if { $setOSImage == "true" } {
			send "no boot system\r"
            expect {
                "% missing parameter detected at" {
                    # maybe Cisco ACE? 
					expect -re $config_prompt
	                send "no boot system image:\r"
	                expect $config_prompt
	                } -re $config_prompt {
	                }
            }

		if {$isC3750 == "true" || $isC3560 == "true"} {
			if {$tarAutoExtracted != "true"} {
				if {$isC3750 == "true"} {
					send "boot system switch all $slot$TFTPFile\r"
				} else {
					send "boot system $slot$TFTPFile\r"
				}
			} else {
				send "\r"
			}
		} else {
    			send "boot system flash $slot$TFTPFile\r"
		}
	    	expect {
				"not found" {
					set ERROR_MESSAGE "Could not set the boot statement to $slot$TFTPFile"
					set ERROR_RESULT true
					expect $config_prompt
                } -re "nvalid (input|parameter)" {
                    expect $config_prompt
                    send "boot system $slot$TFTPFile\r"
                    expect {
                        "not found" {
    						set ERROR_MESSAGE "Could not set the boot statement to $slot$TFTPFile"
    						set ERROR_RESULT true
    						expect -re $config_prompt
                         } -re "% Invalid input" {
    						set ERROR_MESSAGE "Could not set the boot statement to $slot$TFTPFile"
    						set ERROR_RESULT true
                            expect $config_prompt
                         } $config_prompt {
                         }
                    }

				} -re $config_prompt {
				}
    		}
       }
	}
	if { $ERROR_RESULT != "true" } {
		set WARNING_RESULT false
	}
}
