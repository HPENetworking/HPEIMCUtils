
#**************************************************************************
# Identification:delete_directory
# Purpose:       delete directory
#**************************************************************************

proc delete_directory {} {
    global slot
    global enable_prompt
    global ERROR_MESSAGE
    global ERROR_MESSAGE
    global standard_timeout
    set directories ""
    
    send "dir $slot\r"
    set loop true
    while { $loop == "true" } {
        expect {
            -re ".+ +drwx +.+ +.+ (\\S+)" {
                lappend directories $expect_out(1,string)
                expect "*"
            } -re "nvalid" {
            } $enable_prompt {
                set loop false
            }
        }
    
    }

    foreach directory $directories {
        set timeout $long_timeout
        send "del /force /recursive $slot$directory\r"
        expect {
            "Delete filename" {
                send "\r"
                set loop true
                while { $loop == "true" } {
                    expect {
                        "confirm" {
                            send "\r"
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
            } $enable_prompt {
                set ERROR_MESSAGE "An unknown error occurred running the delete command"
                set ERROR_RESULT true
                send "\r"
            }
        }
        expect $enable_prompt
        set timeout $standard_timeout
    }
}
