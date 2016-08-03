
#**************************************************************************
# Identification:backup_startup_config_cli
# Purpose:       backup startup configuration by cli
#**************************************************************************

	set timeout $long_timeout

	send "admin display-config\r\n"
	expect $enable_prompt 

	set timeout $standard_timeout