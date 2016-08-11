#**************************************************************************
# Identification:deploy_image
# Purpose:       deploy image by tftp
#**************************************************************************

	set timeout $long_timeout
	set WARNING_RESULT true
	
	send "copy tftp://$TFTPServer/$TFTPFile image $TFTPDestFile\r"
	
	set loop true
	while { $loop == "true" } {
		expect {
			-re "Unkonwn commmand" {
				expect $enable_prompt
				set loop false
			} -re "TFTP Failed:" {
				set ERROR_RESULT  true
				set ERROR_MESSAGE "Device reports insufficent space to update. Please remove some files."
				expect $enable_prompt
				set loop false
			} -re "Out of memory" {
				set ERROR_RESULT  true
				set ERROR_MESSAGE "Device reports insufficent space to update. Please remove some files."
				expect $enable_prompt
				set loop false
			} -re "transmit error" {
				set ERROR_RESULT  true
				set ERROR_MESSAGE "TFTP update of software image failed. Server may be unreachable from device."
				expect $enable_prompt
				set loop false
			} timeout {
				
			}
		}		
	}
	
		
	set timeout $standard_timeout
