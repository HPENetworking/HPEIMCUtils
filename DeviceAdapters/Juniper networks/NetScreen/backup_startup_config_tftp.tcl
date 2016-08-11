
#**************************************************************************
# Identification:backup_startup_config_tftp
# Purpose:       backup startup configuration by tftp
#**************************************************************************

set timeout $very_long_timeout
set WARNING_RESULT true
send "get config saved > tftp $TFTPServer $TFTPFile $TFTPInterface\r"
expect {
	-re "tftp success" {
	} -re "tftp (abort|timeout max|send rrq error)" {
		set ERROR_MESSAGE "Could not copy configuration to the TFTP server."
		set ERROR_RESULT true
	} -re "redirect tty failed" {
		set plugin1 expect_out(1,string)
		set ERROR_MESSAGE "The TFTP transaction failed: $plugin1"
		set ERROR_RESULT true
	}
}
expect -re $exec_prompt
if { $ERROR_RESULT != "true" } { 
	set WARNING_RESULT false
}
set timeout $standard_timeout