#**************************************************************************
# Identification:get_software_size.tcl
# Purpose:       get device current software size
#**************************************************************************

sleep 1


send "dir $slot:/$TFTPFile\r"
expect {
	-re $more_prompt {
		send " "
	} -re "uthorization failed" {
		set ERROR_MESSAGE "The user is not authorized to use the command dir"
		set ERROR_RESULT true
		expect $enable_prompt
	} -re $enable_prompt {
		# Done
	}		
}