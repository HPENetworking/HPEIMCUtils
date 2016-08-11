
#**************************************************************************
# Identification:exit_config_term
# Purpose:       exit the "config term" mode on the device
#**************************************************************************

if { $enforce_save == "true" } {
	save
}

send "exit\r"
expect { 
	"\\?" { 
		send "yes\r"
		expect $exec_prompt
	} $orig_exec_prompt {
		if {$useTruePrompt != "false"} {
			send "\r"
			expect -re "(.*?$orig_exec_prompt)"
			set exec_prompt $expect_out(1,string)
		}
	} $exec_prompt {
	}
}

if { $ERROR_RESULT != "true" } {
	set WARNING_RESULT false
}