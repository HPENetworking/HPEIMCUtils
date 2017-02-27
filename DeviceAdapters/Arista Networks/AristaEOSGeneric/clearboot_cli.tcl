
#**************************************************************************
# Identification:clearboot_cli
# Purpose:       clearboot_cli
#**************************************************************************

	set WARNING_RESULT true
	if { $slot == "bootflash:" } {
        if { $setBootImage == "true" } {
			send "no boot bootldr\r"
			expect $config_prompt
			send "no boot system\r"
			expect $config_prompt
        }
	}

	if { $slot != "bootflash:" } {
        if { $setOSImage == "true" } { 
			if { $isC3750 == "true" || $isC3560 == "true"} {
				if { $tarAutoExtracted == "true" } {
					send "\r"
				} else {
					send "no boot system\r"
				}
			} else {
				send "no boot system\r"
			}
			expect {
				"% missing parameter detected at" {
					# maybe Cisco ACE? 
					expect $config_prompt
					send "no boot system image:\r"
					expect $config_prompt
				} $config_prompt {
				}
			}
	    }
	}
	if { $ERROR_RESULT != "true" } {
		set WARNING_RESULT false
	}
	