#**************************************************************************
# Identification:get_software_position.tcl
# Purpose:       get device current software position
#**************************************************************************

sleep 1

expect *
send "show system storage\r"
set loop true

while {$loop == "true"} {
	expect {
		-re "$more_prompt" {
			send " "
		} -re "\n.+$error_pattern" {	    
			set error_message $expect_out(1,string)
			expect -re $exec_prompt
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Device error: $error_message"
			set loop false
		} -re $exec_prompt {
			# Done
			set loop false
		}		
	}		
}