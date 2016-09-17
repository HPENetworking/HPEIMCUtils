
#**************************************************************************
# Identification:exit_shell
# Purpose:       quit the "shell" mode on the device
#**************************************************************************

set timeout $standard_timeout
send "exit\r"
expect $exec_prompt