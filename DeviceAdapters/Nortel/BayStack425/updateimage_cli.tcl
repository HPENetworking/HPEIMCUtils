set timeout $image_timeout
send "download address $TFTPServer image $TFTPFile\r"
expect {
    -re "Error (.*)" {
	    set error expect_out(1,string)
	    set ERROR_MESSAGE "Could not copy image from TFTP server: $error"
	    set ERROR_RESULT true
    } -re "Finished Upgrading Image" {
	} -re $enable_prompt {
	}
}
set timeout $standard_timeout