
#**************************************************************************
# Identification:commit_config.tcl
# Purpose:       commit config
#**************************************************************************

set WARNING_RESULT true
send "commit\r"
expect {
	-re "(error: .*)" {
		set error $expect_out(1,string)
		set ERROR_MESSAGE "Unable to commit changes. Device returned $error"
		set ERROR_RESULT true
	} -re $config_prompt {
	} -re $exec_prompt {
	}
} 

if { $ERROR_RESULT != "true" } {
	set WARNING_RESULT false
}