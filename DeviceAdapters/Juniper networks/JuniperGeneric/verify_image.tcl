
#**************************************************************************
# Identification:verify_image.tcl
# Purpose:       verify OS via CLI
#**************************************************************************

set timeout $very_long_timeout
send "request system software validate $slot$DestTFTPFile\r"

expect {
        "truncated or corrupted package" {
	} -re "ERROR: (.*)" {
		set error $expect_out(1,string)
		set ERROR_MESSAGE "Could not verify OS image: $error"
		set ERROR_RESULT true
	} -re "error: (.*)" {
		set error $expect_out(1,string)
		set ERROR_MESSAGE "Could not verify OS image: $error"
		set ERROR_RESULT true
	} "Validation succeeded" {
                expect $exec_prompt
	} $exec_prompt {

        }
}
