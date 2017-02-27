
#**************************************************************************
# Identification:deploy_startup_config_tftp
# Purpose:       depoly startup configuration by tftp
#**************************************************************************

set timeout $very_long_timeout
set WARNING_RESULT true
send "save config from tftp $TFTPServer $TFTPFile $TFTPInterface\r"
expect {
	"unknown keyword" {
		set ERROR_MESSAGE "Invalid TFTP command"
		set ERROR_RESULT true
		expect $exec_prompt
	} -re "(tftp abort|TFTP Failed)" {
		set ERROR_MESSAGE "Could not read file $TFTPFile from server $TFTPServer on $TFTPInterface"
		set ERROR_RESULT true
		expect $exec_prompt
	} "TFTP Succeeded" {
		expect {
			-re "[Ff]ailed[\t ]+[Cc]ommand.*" {
				set ERROR_NONFATAL "true"
				expect $exec_prompt
    		} $exec_prompt {
			}
		}
	}
}
if { $ERROR_RESULT != "true" &amp;&amp; $ERROR_NONFATAL != "true" } {
	set WARNING_RESULT false
}
set timeout $standard_timeout