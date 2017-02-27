
#**************************************************************************
# Identification:backup_startup_config_cli
# Purpose:       backup startup configuration by cli
#**************************************************************************

set timeout $very_long_timeout

# Set the terminal to minimize line wrapping
send "terminal width 132\r"
expect $enable_prompt

# Set the terminal 132 to extend the nr of lines returned between more prompts
# With 0, the device is unstable for large configs
send "terminal length 132\r"
expect $enable_prompt

# Config contains "#" characters, so be careful
send "show running-config\r"
set loop true

while {$loop == "true"} {
	expect {
		-re "$more_prompt" {
			send " "
		} $enable_prompt {
			set loop false
		}
	}
}

set timeout $standard_timeout