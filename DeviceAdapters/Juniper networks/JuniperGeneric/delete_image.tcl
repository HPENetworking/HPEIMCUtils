
#**************************************************************************
# Identification:delete_image.tcl
# Purpose:       delete image file
#**************************************************************************


if { $delete_everything == "true" } {
			
	send "file delete \x2a.tgz\r"
	expect {
		"No such file or directory" {
			set ERROR_MESSAGE "Could not delete *.tgz"
			set ERROR_RESULT true
			$exec_prompt
		} -re $exec_prompt {
		}
	}
			
} else {
	
	send "file delete $slot$TFTPFile\r"
	expect {
		"No such file or directory" {
			set ERROR_MESSAGE "Could not delete $TFTPFile"
			set ERROR_RESULT true
			$exec_prompt
		} -re $exec_prompt {
		}
	}
}
