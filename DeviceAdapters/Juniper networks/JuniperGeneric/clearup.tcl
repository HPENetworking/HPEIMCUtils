            
#**************************************************************************
# Identification:clearup.tcl
# Purpose:       try to recover a prompt, then exit
#**************************************************************************

proc clearup {} {
    global ERROR_RESULT
    global enable_prompt
    global exec_prompt
		
	if { $ERROR_RESULT == "true" } {
		set loop true
		while { $loop == "true" } {
			send "\r"
			expect {
				$enable_prompt {
					send "quit\r"
					set loop false
				} -re $exec_prompt {
					send "quit\r"
					set loop false
				} -re "(Bad|denied)" {
					send "\r"
				}
			}
		}
	}
}