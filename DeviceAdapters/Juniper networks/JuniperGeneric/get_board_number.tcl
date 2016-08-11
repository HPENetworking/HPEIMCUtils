#**************************************************************************
# Identification:get_board_number.tcl
# Purpose:       get device board number which current image is located
#**************************************************************************

sleep 1

send "display boot-loader\r"
set loop true

while {$loop == "true"} {
	expect {
		-re $more_prompt {
			send " "
		} -re "\n.+$error_pattern" {
			expect -re $exec_prompt
			set loop false
		} -re $exec_prompt {
			set loop false
		} "Unrecognized command" {
			set loop false
		}		
	}		
}