
#**************************************************************************
# Identification:delete_file
# Purpose:       delete device file
#**************************************************************************

proc delete_file {} {
    global enable_prompt
    global exec_prompt
    global error_pattern
    global _filename
    
	send "delete /unreserved $_filename\r"
	expect {
		"Y/N" { 
			send "y\r"
		} -re $error_pattern {
			expect -re $exec_prompt
			set ERROR_MESSAGE "The user is not authorized to use the 'system-view' command."
			set ERROR_RESULT  true
		} -re "(can't be found|No such file|Execution failure)" {
		}
	}
	expect -re "($exec_prompt|$enable_prompt)" {
	}
}