
#**************************************************************************
# Identification:exit_enable
# Purpose:       exit the "enable" mode on the device
#**************************************************************************

send "disable\r"\
expect $exec_prompt

    