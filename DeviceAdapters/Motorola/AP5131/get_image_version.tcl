#**************************************************************************
# Identification:get_software_version.tcl
# Purpose:       get device software version
#**************************************************************************

send "system\r"
expect $system_prompt
send "show\r"
expect $system_prompt
return