
#**************************************************************************
# Identification:updateimage_extract_cli
# Purpose:       If tarAutoExtracted, do not extract; the following is for when SCP was used to deploy the tar
#**************************************************************************

	if { $tarAutoExtracted != "true" } {

		set WARNING_RESULT true
		set timeout $very_long_timeout
		send "archive tar /xtract $TFTPFile $slot/\r"
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
			} $enable_prompt {
				send "\r"
			}
		}
		expect $enable_prompt
		set timeout $long_timeout
     if { $ERROR_RESULT != "true" } {
			#Delete tar file
			send "delete /force $slot$TFTPFile\r"
			expect {
				"\\?" {
					send "\r"
                 expect {
                     "confirm" {
                         send "\r"
					        expect $enable_prompt
                     } $enable_prompt {
                     }
                }
             } "Invalid input detected" {
                 expect $enable_prompt
                 send "delete $slot$TFTPFile\r"
                 expect {
                     "\\?" {
                         send "\r"
                         expect "confirm"
                         send "\r"
                         expect $enable_prompt
                     } $enable_prompt {
                     }
                }
				} $enable_prompt {
				}
			}
			set WARNING_RESULT false
		}			

		set timeout $standard_timeout
	}
	