#**************************************************************************
# Identification:backup_startup_config_tftp
# Purpose:       backup startup configuration by tftp
#**************************************************************************

set timeout $very_long_timeout
send "\x08\x08"
send "copy running-config tftp address $TFTPServer filename $TFTPFile\r"
set loop true


while { $loop == "true" } {

	expect {
		  "Config file transfer operation already in progress." {
		  	set ERROR_MESSAGE "Config file transfer operation already in progress."
			set ERROR_RESULT true
			set loop false
			expect $priv_exec_prompt
		} "Intra-stack communication failure" {
			set ERROR_MESSAGE "A problem occured on the device: Intra-stack communication failure"
			set ERROR_RESULT true
			set loop false
			expect $priv_exec_prompt
		} "Operation aborted" {
			set ERROR_MESSAGE "A problem occured on the device: Operation aborted"
			set ERROR_RESULT true
			set loop false
			expect $priv_exec_prompt
		} "Invalid input" {
			set ERROR_MESSAGE "Could not run the command copy config tftp"
			set ERROR_RESULT true
			set loop false
			expect $priv_exec_prompt
		} "Access is read-only" {
			set ERROR_MESSAGE "The current user has read-only access and cannot copy the configuration to the TFTP server. Please check the login credentials for this device."
			set ERROR_RESULT true
			set loop false
			expect $priv_exec_prompt
		} "% Cannot start upload of config file." {
			set ERROR_MESSAGE "The previous config-file upload/download operation is still in progress."
			set ERROR_RESULT true
			set loop false
			expect $priv_exec_prompt
		} $priv_exec_prompt {
			set loop false
		}
	}

}

set timeout $standard_timeout
send "\r"
expect {
	"Invalid input detected" {
		set ERROR_RESULT true
		set ERROR_MESSAGE "The script could not synchronize with the device."
		cleanup
		exit
	} $priv_exec_prompt {
	}
}
