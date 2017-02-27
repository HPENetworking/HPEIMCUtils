
#**************************************************************************
# Identification:getversion_cli
# Purpose:       getversion_cli
#**************************************************************************


send "show version\r"
set loop true
while {$loop == "true"} {
	expect {
		"C3750" {
			set isC3750 "true"
		} "C3560" {
			set isC3560 "true"
		} "C2960" {
			set isC3560 "true"
		} "C3550" {		   
			set isC3560 "true"
		} -re $more_prompt {
			send " "
		} "Device#" {
		}	-re "uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command show version"
			set ERROR_RESULT true
			expect $enable_prompt
		} -re $enable_prompt {
		  send "\r"
		  expect -re $enable_prompt
		  set loop false
		} 
	} 
}	
	
	if {$deletebins == "true"} {
	send "dir ?"
	set loop "true"
	while { $loop == "true" } {
		expect {
			-re "(\\S+:)" {
				lappend locations $expect_out(1,string)
				expect "*"
			} "% Invalid" {
				set ERROR_MESSAGE "Could not run the command dir"
				set ERROR_RESULT true
			} -re $enable_prompt {
				set loop false
			}
		}
	}
	
	# The dir command will still be on the command line 
	send "\x15" # Control-U
	set timeout 60
	foreach entry $locations { 
		if { $entry != "bs:" } {
			send "dir $entry\r"
            set loop "true"
    		while { $loop == "true" } {
                 set loop "false"
                 expect {
                      "Device in exclusive use" {
                           set ERROR_RESULT true
                           set ERROR_MESSAGE "Could not open $entry for directory listing."
                       } "uthorization failed" { 
                           set ERROR_MESSAGE "The user is not authorized to run the dir command"
                           set ERROR_RESULT true
                       } "% Invalid" {
                           set ERROR_MESSAGE "Could not run the command dir"
                           set ERROR_RESULT true
                       } -re "-rwx.+(\\S+\.bin)" {
                            set binfile $expect_out(1,string)
			      	        if {$entry != "/all"} {
								lappend bins $entry$binfile
								expect "*"
							}
							set loop "true"
		               } -re $enable_prompt {
                       }
                    }
                    sleep 1  # Pause one second for safety
            }
	    } 
    }
	foreach entry $bins {
		set timeout 60
		send "delete $entry\r"
		expect "\\?"
		send "\r"
		expect "\\?"
		send "\r"
		expect $enable_prompt
		sleep 1
	}
	}
