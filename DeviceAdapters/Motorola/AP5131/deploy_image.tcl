
#**************************************************************************
# Identification:deploy_image.tcl
# Purpose:       deploy image to device by cli
#**************************************************************************

send "system\r"
	expect $system_prompt
    send "fw-update\r"
    expect $fwupdate_prompt
	send "set file $TFTPFile\r"
	expect $fwupdate_prompt
	send "set server $TFTPServer\r"
	expect $fwupdate_prompt
	send "update tftp\r"
	expect "Load complete. System will now reset to update"
	close

