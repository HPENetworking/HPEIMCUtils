
#**************************************************************************
# Identification:deploy_image_scp_cli.tcl
# Purpose:       deploy image to device by cli
#**************************************************************************

if { $SSHUser == "" } {
    set ERROR_RESULT true
    set ERROR_MESSAGE "The SSHUser configuration option must be set in Administrative Options, Device Access"
}
if { $ERROR_RESULT != "true" } {
    set timeout 1000
    set WARNING_RESULT true
    send "file copy scp://$SSHUser@$TFTPServer/$TFTPFile $TFTPFile\r"
	set loop true
	while {$loop == "true"} {
		expect {
			"continue connecting (yes/no)?" {
                send "yes\r"
			} "assword:" {
				send "$SSHPassword\r"
				set loop false
			} -re "(error.*)" {
				set plugin $expect_out(1,string)
				set ERROR_RESULT true
				set ERROR_MESSAGE $plugin
				set loop false
			}
		}
	}
	expect {
		-re "(error.*)" {
			set plugin $expect_out(1,string)
			set ERROR_RESULT true
			set ERROR_MESSAGE $plugin
			expect $exec_prompt
		} -re $exec_prompt {
		}
	}
		
	set timeout $standard_timeout
    if { $ERROR_RESULT != "true" } {
		set WARNING_RESULT false
	}			
}