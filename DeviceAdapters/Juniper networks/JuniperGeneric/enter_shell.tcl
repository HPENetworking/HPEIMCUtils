
#**************************************************************************
# Identification:enter_shell
# Purpose:       enter the "shell" mode on the device
#**************************************************************************

set timeout $standard_timeout

send "start shell\r"
expect {
    $shell_prompt {
        #ok
    } -re $error_pattern {
        set error_message $expect_out(1,string)
	expect -re $exec_prompt
	set ERROR_RESULT  true
	set ERROR_MESSAGE "Device error: $error_message"
    }
}
