
#**************************************************************************
# Identification:delete_image.tcl
# Purpose:       delete image file
#**************************************************************************

delete_file

send "squeeze $slot\r"
expect {
	"Invalid input detected" {
		# slavedisks cannot be squeezed 
		if {$slot != "slavedisk0:" && $slot != "slavedisk1:"} {
			# This may occur on some low end devices ... 
			send "squeeze ?"
			expect {
				"flash:" {
					set ERROR_MESSAGE "Could not squeeze $slot"
					set ERROR_RESULT true
				
				} "% Unrecognized command" {
					# Acceptable error 
					# need to clear the prompt 
					expect "*"
					send "\x15\r"
                	set cannotSqueeze true
				}
			}
		} else {
			set cannotSqueeze true
		}
		} "invalid command detected at" {
           set cannotSqueeze true
	} "confirm" {
		send "\r"
		# two minutes may be a risky bet; try 3 
		set timeout $squeeze_timeout
		expect { 
			"confirm" {
				send "\r"
				expect {
					"complete" {
					} -re "Error squeezing \\S+ (.*)" {
						set error $expect_out(1,string)
						set ERROR_MESSAGE "Could not squeeze $slot - $error"
						set ERROR_RESULT true
					}
				}
			} -re "Error squeezing \\S+" {
				# Expected error on low end devices; accept it 
                set cannotSqueeze true
			} "complete" {
			}
		}
		set timeout $standard_timeout
	} "uthorization failed" {
		set ERROR_MESSAGE "The user is not authorized to use the command squeeze"
		set ERROR_RESULT true
	} $enable_prompt {
		#set ERROR_MESSAGE "An unknown error occurred running the squeeze command"
		#set ERROR_RESULT true
		#may be command not recognized
		set cannotSqueeze true
		send "\r"
	}
}
expect $enable_prompt	

if { $cannotSqueeze != "true" } {
	return	
}

sleep 1
send "erase $slot\r"
set timeout $squeeze_timeout
set loop "true"
while { $loop == "true" } {
	expect { 
		"confirm" {
			send "\r"
			expect {
				"complete" {
				    set loop "false"
				} -re "Error erasing \\S+ (.*)" {
					set error $expect_out(1,string)
					set ERROR_MESSAGE "Could not squeeze $slot - $error"
					set ERROR_RESULT true
					set loop "false"
				} -re "Invalid input detected" {
					set loop "false"
				} "complete" {	
				   set loop "false"
				} 
			}
		} -re "Invalid input detected" {
			set loop "false"
		} "complete" {
		    set loop "false"
		} 
	}
}
set timeout $standard_timeout
