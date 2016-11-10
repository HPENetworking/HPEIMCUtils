
#**************************************************************************
# Identification:deploy_image_ftp.tcl
# Purpose:       deploy image to device by cli
#**************************************************************************

set timeout 1800
set WARNING_RESULT true
send "file copy ftp://$FTPUser@$TFTPServer/$TFTPFile $slot$DestTFTPFile\r"
set loop true
while {$loop == "true"} {
	expect {
		-re "Password.*:" {
            send "$FTPPassword\r"
            set loop false
		} -re "(error.*)" {
			set plugin $expect_out(1,string)
			set ERROR_RESULT true
			set ERROR_MESSAGE $plugin
			set loop false
			return
		}
	}
}
expect {
	-re "(error.*)" {
		set plugin $expect_out(1,string)
		set ERROR_RESULT true
		set ERROR_MESSAGE $plugin
		#expect $exec_prompt
		return
	} -re $exec_prompt {
	}
}

set timeout $standard_timeout
expect $exec_prompt
