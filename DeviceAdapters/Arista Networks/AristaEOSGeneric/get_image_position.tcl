#**************************************************************************
# Identification:get_software_position.tcl
# Purpose:       get device current software position
#**************************************************************************

sleep 1

send "show version\r"
set loop true
while {$loop == "true"} {
	expect {
      -re $more_prompt {
			send " "
		} "Device#" {
		}	-re "uthorization failed" {
			set ERROR_MESSAGE "The user is not authorized to use the command show version"
			set ERROR_RESULT true
			expect $enable_prompt
		} -re $enable_prompt {
		  send "\r"
		  expect -re $enable_prompt
		  set loop false
		} 
	} 
}	