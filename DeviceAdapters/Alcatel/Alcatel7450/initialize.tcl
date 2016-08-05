
#**************************************************************************
# Identification:initialize
# Purpose:       initialize variables
#**************************************************************************

	set standard_timeout 10
	set long_timeout 60
	set very_long_timeout 120
	set squeeze_timeout 300
	set username_prompt ogin:
	set login_prompt "ogin as:"
	set password_prompt assword:
	set enable_prompt #
	set exec_prompt #
	set config_prompt "config(\S*)#"
	set orig_enable_prompt "# "
	set orig_config_prompt config#
	set enforce_save false
	set timeout $standard_timeout
	set more_prompt "Press any key to continue"
	set pause $more_prompt
	set sent_password "false"
	set banner_skip_repeat 0