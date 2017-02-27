
#**************************************************************************
# Identification:updateimage_extract_cli
# Purpose:       updateimage_extract_cli
#**************************************************************************

	set WARNING_RESULT true
	set timeout $very_long_timeout
	if {$isC3750 == "true" || $isC3560 == "true"} {
		set timeout 1000
		send "archive download-sw /overwrite tftp://$TFTPServer/$TFTPFile\r"
	} else {

		send "archive tar /xtract tftp://$TFTPServer/$TFTPFile $slot\r"
	}
	expect {
		-re "Error: (.*)" {
			set error $expect_out(1,string)
			set ERROR_MESSAGE "Could not extract $TFTPFile : $error"
			set ERROR_RESULT true
			set timeout $standard_timeout
		} -re "Error (.*)" {
			set error $expect_out(1,string)
			set ERROR_MESSAGE "Could not extract $TFTPFile: Error $error"
			set ERROR_RESULT true
		} "Invalid input" {
			set ERROR_MESSAGE "Could not extract $TFTPFile : Invalid command"
			set ERROR_RESULT true
		} "OK -" {
			expect {
				-re "Error: (.*)" {
					set error $expect_out(1,string)
					set ERROR_MESSAGE "Could not extract $TFTPFile : $error"
					set ERROR_RESULT true
					set timeout $standard_timeout
				} -re "Error (.*)" {
					set error $expect_out(1,string)
					set ERROR_MESSAGE "Could not extract $TFTPFile: Error $error"
					set ERROR_RESULT true
				} $enable_prompt {
				}
			}
		} -re $enable_prompt {
		}
	}
	if { $ERROR_RESULT != "true" } {
		set WARNING_RESULT false
		set tarAutoExtracted true
	}
	