
#**************************************************************************
# Identification:save_config.tcl
# Purpose:       set the device next startup image by cli
#**************************************************************************

send "save\r"
expect -re $exec_prompt
