
#**************************************************************************
# Identification:enter_config_term
# Purpose:       enter the "config_term" mode on the device
#**************************************************************************

send "configure\r"
expect -re "terminal"

send "\r"
expect $config_prompt