
#**************************************************************************
# Identification:deploy_image_ftp.tcl
# Purpose:       deploy image to device by cli
#**************************************************************************

set timeout 1200

send "cd $slot\r"
expect $shell_prompt 

send "ftp $TFTPServer\r"
expect {
    "Command not found" {
        set ERROR_RESULT true
	set ERROR_MESSAGE "Command not found"
    } "Operation timed out" {
        set ERROR_RESULT true
	set ERROR_MESSAGE "Operation timed out"
    } "Connection refused" {
        set ERROR_RESULT true
	set ERROR_MESSAGE "Connection refused"
    } "Not connected" {
        set ERROR_RESULT true
	set ERROR_MESSAGE "Not connected"
    } "):" {

    }

}

send "$FTPUser\r"
expect "Password:"
send "$FTPPassword\r"
expect {
    "Login failed" {
        set ERROR_RESULT true
	set ERROR_MESSAGE "Login failed"
        expect "ftp>"
        send "quit\r"
        expect $shell_prompt
    } "No control connection for command" {
        set ERROR_RESULT true
	set ERROR_MESSAGE "No control connection for command"
        expect "ftp>"
        send "quit\r"
        expect $shell_prompt
    } "Not connected" {
        set ERROR_RESULT true
	set ERROR_MESSAGE "Not connected"
        expect "ftp>"
        send "quit\r"
        expect $shell_prompt
    } "ftp>" {
    }
}

send "bin\r"
expect "ftp>"

send "get $TFTPFile $DestTFTPFile\r"
expect {
    "Login failed" {
        set ERROR_RESULT true
	set ERROR_MESSAGE "Login failed"
        expect "ftp>"
        send "quit\r"
        expect $shell_prompt
    } "No control connection for command" {
        set ERROR_RESULT true
	set ERROR_MESSAGE "No control connection for command"
        expect "ftp>"
        send "quit\r"
        expect $shell_prompt
    } "Not connected" {
        set ERROR_RESULT true
	set ERROR_MESSAGE "Not connected"
        expect "ftp>"
        send "quit\r"
        expect $shell_prompt
    } "Transfer OK" {
       expect "ftp>"
        send "quit\r"
        expect $shell_prompt
    } "ftp>" {
        set ERROR_RESULT true
	set ERROR_MESSAGE "Transfer failed"
        send "quit\r"
        expect $shell_prompt
    }
}

sleep 1

set timeout $standard_timeout
