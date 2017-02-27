
#**************************************************************************
# Identification:verifyimage_cli
# Purpose:       verifyimage_cli
#**************************************************************************

    set WARNING_RESULT true
    set timeout $long_timeout
    if { $verifyImage == "true" } {
        send "verify /md5 $slot$TFTPFile $md5Checksum\r"
        expect {
            -re "%Error (.*)" {
                set error $expect_out(1,string)
                set ERROR_MESSAGE "Error verifying image: Error $error"
                set ERROR_RESULT true
            } "% Invalid" {
                expect $enable_prompt
                send "verify $slot$TFTPFile\r"
                expect {
                    -re "%Error (.*)" {
                        set error $expect_out(1,string)
                        set ERROR_MESSAGE "Error verifying image: Error $error"
                        set ERROR_RESULT true
                     } "Verified" {
                    }
                }
            } "Verified" {
            } $enable_prompt {
                set ERROR_MESSAGE "MD5 Checksum did not match expected $md5Checksum"
                set ERROR_RESULT true
                send "\r"
            }
        }
        expect $enable_prompt
    }
    set timeout $standard_timeout

    