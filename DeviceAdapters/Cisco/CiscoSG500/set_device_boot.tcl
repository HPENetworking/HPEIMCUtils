#**************************************************************************
# Identification:set_device_boot
# Purpose:       set device boot by tftp
#**************************************************************************

	set timeout $long_timeout
	set WARNING_RESULT true
	
	send "boot flash $TFTPFile\r"
	
	set loop true
	
	while { $loop == "true" } {
		expect {
			-re "Install operation failed" {
				set ERROR_RESULT  true
				set ERROR_MESSAGE "Device reports insufficent space to update. Please remove some files."
				expect $admin_prompt
				set loop false
			} -re "Skipped adding the following package as it was already present" {
				set ERROR_RESULT  true
				set ERROR_MESSAGE "Device reports insufficent space to update. Please remove some files."
				expect $admin_prompt
				set loop false
			} -re "Install operation completed successfully" {
				expect $enable_prompt
				set loop false
			}
		}
	}
	
		
	set timeout $standard_timeout
