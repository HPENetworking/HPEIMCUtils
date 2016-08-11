
#**************************************************************************
# Identification:load_image.tcl
# Purpose:       set the device next startup image by cli
#**************************************************************************

set timeout $very_long_timeout
send "request system software add $slot$TFTPFile no-validate\r"
expect {
	-re "ERROR: (.*)" {
		set error $expect_out(1,string)
		set ERROR_MESSAGE "Could not load OS image: $error"
		set ERROR_RESULT true
		return
	} -re "error: (.*)" {
		set error $expect_out(1,string)
		set ERROR_MESSAGE "Could not load OS image: $error"
		set ERROR_RESULT true
		return
	} -re "Installing package" {
                #begin
	} "Checking pending install" {
                #begin
        }
}

expect {
	-re "ERROR: (.*)" {
		set error $expect_out(1,string)
		set ERROR_MESSAGE "Could not load OS image: $error"
		set ERROR_RESULT true
		return
	} -re "error: (.*)" {
		set error $expect_out(1,string)
		set ERROR_MESSAGE "Could not load OS image: $error"
		set ERROR_RESULT true
		return
	} -re "$exec_prompt" {
	}
}

set timeout $standard_timeout
