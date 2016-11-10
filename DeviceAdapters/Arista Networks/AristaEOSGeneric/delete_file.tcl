
#**************************************************************************
# Identification:delete_file
# Purpose:       delete device file
#**************************************************************************

proc delete_file {} {
    global slot
    global enable_prompt
    global exec_prompt
    global error_pattern
    global TFTPFile
    global long_timeout
    global standard_timeout
    
    send "del /force $slot/$TFTPFile\r"
    expect {
        "Delete filename" {
            send "\r"
            set loop true
            while { $loop == "true" } {
                expect {
                    -re "confirm|nfirm]" {
                        send "\r"
                    } "Is a directory" {
                        expect $enable_prompt
                        set timeout $long_timeout
                        send "del /force /recursive $slot$TFTPFile\r"
                        expect {
                            "Delete filename" {
                                send "\r"
                            } -re "nvalid (input|command)" {
                                set ERROR_RESULT true
                            }
                       }
                    } $enable_prompt {
                        set loop false
                        send "\r" 
                    }
                }
            }
        } "File delete error" {
        } -re "nvalid (input|command)" {
            set ERROR_MESSAGE "Could not delete images from $slot"
            set ERROR_RESULT true
        } "uthorization failed" {
            set ERROR_MESSAGE "The user is not authorized to use the command delete"
            set ERROR_RESULT true
        } "File not found" {
            #fiel not exist
            return
        } $enable_prompt {
            set ERROR_MESSAGE "An unknown error occurred running the delete command"
            set ERROR_RESULT true
            send "\r"
        }
    }
    expect $enable_prompt
    set timeout $standard_timeout
}