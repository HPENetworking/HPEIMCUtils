
#**************************************************************************
# Identification:backup_startup_config_tftp
# Purpose:       backup startup configuration by tftp
#**************************************************************************

set timeout $very_very_long_timeout
set WARNING_RESULT true

send "copy config tftp address $TFTPServer filename $TFTPFile\r"
expect {
	-re "(nvalid input.*)" {
		set error $expect_out(1,string)
		set ERROR_MESSAGE "Device returned error: $error"
		set ERROR_RESULT true
	} "TFTP operation timedout" {
		set ERROR_RESULT true
		set ERROR_MESSAGE "TFTP server timed out; check network connections."
	} "ERROR" {
		set ERROR_RESULT true
		set ERROR_MESSAGE "TFTP server timed out; check network connections."
	} "successfully written" {
		# Success
	}
}
expect $enable_prompt

if { $ERROR_RESULT != "true" } {
	set WARNING_RESULT false
}
set timeout $standard_timeout