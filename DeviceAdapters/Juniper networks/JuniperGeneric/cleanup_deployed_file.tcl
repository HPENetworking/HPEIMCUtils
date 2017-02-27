
#**************************************************************************
# Identification:cleanup_deployed_file.tcl
# Purpose:       cleanup deployed file
#**************************************************************************

set WARNING_RESULT true
send "file delete rn_config\r"
expect {
	-re "\\d+ errors" {
		#set ERROR_MESSAGE "Could not delete rn_config."
		#set ERROR_RESULT true
	} -re "error: (.*)" {
		#set error $expect_out(1,string)
		#set ERROR_MESSAGE "Could not delete rn_config: $error"
		#set ERROR_RESULT true
	} -re $exec_prompt {
	}
}

if { $ERROR_RESULT != "true" } {
	set WARNING_RESULT false
}