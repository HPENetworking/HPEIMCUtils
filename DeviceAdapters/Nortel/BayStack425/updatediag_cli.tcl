set timeout $image_timeout
send "download address $TFTPServer diag $TFTPFile\r"
expect {
    -re "Error (.*)" {
	    set error expect_out(1,string)
	    set ERROR_MESSAGE "Could not copy diag image from TFTP server: $error"
	    set ERROR_RESULT true
	} -re "Invalid image" {
		set ERROR_MESSAGE "Could not deploy image to device. Invalid image detected."
		set ERROR_RESULT true
	} "Finished Upgrading" {
	
	} -re "Ethernet Switch" {
		sleep $switch_sleep
	} -re $enable_prompt {
	
	}
}
set timeout $standard_timeout