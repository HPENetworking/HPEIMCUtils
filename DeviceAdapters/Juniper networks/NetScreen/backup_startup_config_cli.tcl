
#**************************************************************************
# Identification:backup_startup_config_cli
# Purpose:       backup startup configuration by cli
#**************************************************************************

expect "*"
send "get config saved\n"
expect $exec_prompt