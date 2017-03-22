#**************************************************************************
# Identification:deploy_startup_config_tftp
# Purpose:       deploy startup configuration by tftp
#**************************************************************************

set timeout $standard_timeout
sleep 1

expect -re $exec_prompt {
}

send "system\r"
expect -re "system.*"
send "config\r"
expect -re "system.config.*"
send "set server $TFTPServer\r"
expect -re "system.config.*"
send "set file $TFTPFile\r"
expect -re "system.config.*"
send "import tftp\r"
expect -re "Import Operation*.*Done.*"
send "..\r"
expect -re "system.*"
send "..\r"

expect -re $exec_prompt {
}