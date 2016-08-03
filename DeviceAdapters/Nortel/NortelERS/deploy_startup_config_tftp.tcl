
#**************************************************************************
# Identification:deploy_startup_config_tftp
# Purpose:       deploy startup configuration by tftp
#**************************************************************************

# Device config is about 1MB... 4-5 minutes to download
set timeout $very_very_long_timeout
set WARNING_RESULT true

send "copy config address $TFTPServer filename $TFTPFile\r"
sleep 100
expect {
	"TFTP operation timedout" {
		set ERROR_RESULT true
		set ERROR_MESSAGE "TFTP server timed out; check network connections."
	} "download successful" {
		# Success
		expect "Performing reconfiguration"
	}
}
expect $enable_prompt

if { $ERROR_RESULT != "true" } {
	set WARNING_RESULT false
}
set timeout $standard_timeout