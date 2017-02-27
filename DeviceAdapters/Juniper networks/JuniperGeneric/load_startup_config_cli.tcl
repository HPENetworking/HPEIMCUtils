
#**************************************************************************
# Identification:deploy_startup_config_cli
# Purpose:       deploy startup configuration by cli
#**************************************************************************

set timeout $very_long_timeout
set WARNING_RESULT true
send "load override rn_config\r"

set ERROR_RESULT ""
set WARNING_RESULT false

expect {
	-re "\\d+ errors" {
		set ERROR_MESSAGE "Could not override the configuration due to errors in the deployed configuration."
		set ERROR_RESULT true
	} -re "error: (.*)" {
		set ERROR_MESSAGE "Could not load configuration."
		set ERROR_RESULT true
	} "load complete" {
	}
}
expect $config_prompt
if { $ERROR_RESULT != "true" } {
	set WARNING_RESULT true
	send "commit\r"
	expect { 
		-re "warning: (.*)" {
			#set error $expect_out(1,string)
			#set ERROR_MESSAGE "Could not commit configuration: $error"
			#set ERROR_RESULT true
                  expect -re $config_prompt
		} -re "error: (.*)" {
			#set error $expect_out(1,string)
			#set ERROR_MESSAGE "Could not commit configuration: $error"
			#set ERROR_RESULT true
                  expect -re $config_prompt
		} -re "commit complete" {
		}
	}
	expect -re $config_prompt

	if { $ERROR_RESULT != "true" } {
		send "save configuration\r"
		expect { 
			-re "warning: (.*)" {
				set error $expect_out(1,string)
				set ERROR_MESSAGE "Could not save configuration: $error"
				set ERROR_RESULT true
				expect $config_prompt
			} -re "error: (.*)" {
				set error $expect_out(1,string)
				set ERROR_MESSAGE "Could not save configuration: $error"
				set ERROR_RESULT true
				expect $config_prompt
			} $config_prompt {
			}
		}
	}
} else {
	send "rollback\r"
	expect {
		-re "warning: (.*)" {
			set error $expect_out(1,string)
			set ERROR_MESSAGE "Could not save configuration: $error"
			set ERROR_RESULT true
			expect $config_prompt
		} -re "error: (.*)" {
			set error $expect_out(1,string)
			set ERROR_MESSAGE "Could not save configuration: $error"
			set ERROR_RESULT true
			expect $config_prompt
		} "load complete" {
			expect $config_prompt
		}
	}
}

if { $ERROR_RESULT != "true" } {
	set WARNING_RESULT false
}
set timeout $standard_timeout