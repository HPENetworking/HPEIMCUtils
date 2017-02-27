
#**************************************************************************
# Identification:deploy_image_cli.tcl
# Purpose:       deploy image to device by cli
#**************************************************************************

set timeout $squeeze_timeout

set my_cmd "copy $MainSlot$CopyFile $CopyFlash$CopyFile"

send "$my_cmd\r"
set loop true

while { $loop == "true"} {
    expect {
	    "Not enough space" {
	        set loop false
		    set ERROR_RESULT true
		    set ERROR_MESSAGE "insufficient space on device."
	    } "no enough space" {
	        set loop false
		    set ERROR_RESULT true
		    set ERROR_MESSAGE "insufficient space on device."
	    } -re "Error:(.*)\n|\n Wrong filename" {
	        set loop false
		    set ERROR_RESULT true
		    set ERROR_MESSAGE "Device returned an error"
	    } "estination filename" {
	        send "\r";
	    } "over write" {
	        send "\r";
	    } "% Incomplete" {
	        set loop false
		    set ERROR_RESULT true
		    set ERROR_MESSAGE "Device returned an error"
	    } "bytes copied" {
	        expect $enable_prompt
	        set loop false
	        #success
	    }
    }
}

set timeout $standard_timeout	