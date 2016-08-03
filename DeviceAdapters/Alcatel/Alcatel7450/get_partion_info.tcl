#**************************************************************************
# Identification:get_partion_info.tcl
# Purpose:       get device partion info
#**************************************************************************

sleep 1

send "dir\r"
set loop true

while {$loop == "true"} {
	expect {
		-re $more_prompt {
			send " "
		} -re "Invalid.*|Error .*|Incomplete.*|Wrong.*" {
			expect -re $enable_prompt
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Wrong command"
			set loop false
		} -re $enable_prompt {
			# Done
			set loop false
		} 
	}		
}