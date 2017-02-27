#**************************************************************************
# Identification:deploy_startup_config_tftp
# Purpose:       deploy startup configuration by tftp
#**************************************************************************

set timeout $very_long_timeout

set WARNING_RESULT true
set WARNING_MESSAGE "Configuration download to this device will ignore certain settings from the old configuration, such as IP values, and will reset passwords to hard-coded defaults.\nThe device now has hard-coded default passwords.\nYou should change these as soon as possible."
send "copy tftp config address $TFTPServer filename $TFTPFile\r"
set loop true
while { $loop == "true" } {
	expect {
		"Not enough data in file." {
			set ERROR_MESSAGE "Configure net failed: Not enough data in file."
			set ERROR_RESULT true
		} "Data CRC failure" {
			set ERROR_MESSAGE "Configuration failed to pass a CRC check on the device."
			set ERROR_RESULT true
		} "Access is read-only" {
			set ERROR_MESSAGE "The current user has read-only access and cannot copy the configuration to the TFTP server. Please check the login credentials for this device."
			set ERROR_RESULT true
		} "Config file download successful." {
			set loop false
			# note that the device reboots at this point
			close
		} $priv_exec_prompt {
			set loop false
			set ERROR_MESSAGE "The device did not reload with the deployed configuration."
			set ERROR_RESULT true
		}
	}
}
if {$ERROR_RESULT == "true"} {
	set WARNING_RESULT false
}

set timeout $standard_timeout