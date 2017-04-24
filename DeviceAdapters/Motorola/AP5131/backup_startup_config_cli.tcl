set timeout $standard_timeout
sleep 1

expect -re $exec_prompt {
}

send "system\r"
expect -re "system)>"
send "config\r"
expect -re "system.config)>"
send "set server 10.0.30.52\r"
send "set file AP5131.cfg\r"
send "export tftp/r"
send "../r"
send "../r"

expect -re $exec_prompt {
}
