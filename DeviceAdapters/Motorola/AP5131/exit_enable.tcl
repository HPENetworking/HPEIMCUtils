#**************************************************************************
# Identification:exit_enable
# Purpose:       quit the "enable" mode on the device
#**************************************************************************

send "\r\r"
expect $exec_prompt	