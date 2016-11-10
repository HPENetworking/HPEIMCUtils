#**************************************************************************
# Identification:exit_admin
# Purpose:       exit the "admin" mode on the device
#**************************************************************************

    send "exit\r"
    expect $enable_prompt
    