
#**************************************************************************
# Identification:determine_boot
# Purpose:       determine_boot
#**************************************************************************

	set WARNING_RESULT true
	send "! $TFTPFile\r"
	expect $enable_prompt

    if { $ERROR_RESULT != "true" } {
		set WARNING_RESULT false
	}			
	