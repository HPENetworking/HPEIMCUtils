
#**************************************************************************
# Identification:set_device_boot.tcl
# Purpose:       set current software to backup
#**************************************************************************
    

set SEND_CMD true
if { $CurImage != "" && $PosImage != "" } {
	if { $SEND_CMD } {
		send "boot system flash $PosImage$CurImage\r"
		expect {
			-re "Unrecognized|Incomplete|Too many|Ambiguous|not support" {
				expect -re $exec_prompt
			} -re $config_prompt {
				set SEND_CMD false
				return
			}
		}
	}
	if { $SEND_CMD } {
		send "boot system $PosImage$CurImage\r"
		expect {
			-re "Unrecognized|Incomplete|Too many|Ambiguous|not support" {
				expect -re $exec_prompt
			} -re $config_prompt {
				set SEND_CMD false
				return
			}
		}
	}	 
}

if { $SEND_CMD } {
	set ERROR_MESSAGE "Incorrect command. Could not backup current software to the device. Do not support"
	set ERROR_RESULT true
	set SEND_CMD false
	return
}

