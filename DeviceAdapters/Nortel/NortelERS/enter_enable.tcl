
#**************************************************************************
# Identification:enter_enable
# Purpose:       enter the "enable" mode on the device
#**************************************************************************

send "enable\r"
expect $enable_prompt
if {$useTruePrompt != "false" } {
	send "\r"
	expect -re "(.*?$enable_prompt)"
	set enable_prompt $expect_out(1,string)
}				