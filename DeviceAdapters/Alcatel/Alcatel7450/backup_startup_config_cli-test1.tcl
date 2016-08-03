
#**************************************************************************
# Identification:backup_startup_config_cli
# Purpose:       backup startup configuration by cli
#**************************************************************************

	set timeout $long_timeout

	send "admin display-config\r\n"

	set loop true

	while {$loop == "true"} {

		expect {
			-re "$more_prompt" {
				send " "
			}
			-re "$enable_prompt" {
			set loop false
			}
		 }
	}
	set timeout $standard_timeout