
#**************************************************************************
# Identification: save.tcl
# Purpose:        save device configuration
#**************************************************************************
proc save {} {
    global enable_prompt 
    global standard_timeout 
    global very_long_timeout 

	set timeout $very_long_timeout
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
		} $enable_prompt {
		}
	}
	set timeout $standard_timeout
}