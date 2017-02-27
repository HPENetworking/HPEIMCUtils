
#**************************************************************************
# Identification:enter_config_terminal
# Purpose:       enter the "config terminal" mode on the device
#**************************************************************************

    send "config terminal\r"
    expect {
        -re "nvalid" {
            set ERROR_MESSAGE "Could not enter configuration mode."
            set ERROR_RESULT true
            expect $enable_prompt
        } "uthorization failed" {
            set ERROR_MESSAGE "The user is not authorized to enter configuration mode."
            set ERROR_RESULT true
            expect $enable_prompt
        } -re $config_prompt {
        }
    }
    