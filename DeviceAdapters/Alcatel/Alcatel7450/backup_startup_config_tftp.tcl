
#**************************************************************************
# Identification:backup_startup_config_tftp
# Purpose:       backup startup configuration by tftp
#**************************************************************************


	set timeout $very_long_timeout
	set WARNING_RESULT true
	send "admin save tftp://$TFTPServer/$TFTPFile\r\n"
    expect {
    	-re "(Upload failed|Cannot write configuration)" {
    		set ERROR_RESULT  true
    		set ERROR_MESSAGE "TFTP configuration upload failed. Server may be down or unreachable."
    	} $enable_prompt {
    		# Success
    	}
	}
	if { $ERROR_RESULT != "true" } {
		set WARNING_RESULT false
	}
	set timeout $standard_timeout