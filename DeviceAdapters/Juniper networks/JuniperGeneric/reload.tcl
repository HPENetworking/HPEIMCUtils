
#**************************************************************************
# Identification:reload.tcl
# Purpose:       reload device
#**************************************************************************

expect "*"

#set timeout 60
send "request system reboot\r"

set loop true
while {$loop == "true"} {
  expect {
     -re "Reboot" {
       send "yes\r"
       set loop flase
       #close
    } -re $exec_prompt {
       set loop flase
    }
  }
}

set timeout 4