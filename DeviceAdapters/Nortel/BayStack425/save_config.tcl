
#**************************************************************************
# Identification:save_config.tcl
# Purpose:       save device configuration
#**************************************************************************

send "save\r"
expect -re $enable_prompt