
#**************************************************************************
# Identification:initialize
# Purpose:       initialize variables
#**************************************************************************
   
    set switch_sleep 0
	set standard_timeout 10
	set long_timeout 30
	set very_long_timeout 100
	set image_timeout 300
	set send_delay 2.0
	set timeout $standard_timeout
	set initial_prompt "Ctrl-Y to|###      ###"
	set username_prompt "Enter Username:"
	set password_prompt "Enter Password:"
	set orig_exec_prompt ">"
	set enable_prompt "#"
	set exec_prompt ">"
	set priv_exec_prompt "#"
	set config_prompt ")#"
    set pause_prompt "--More"
	set pause $pause_prompt
	set banner_skip_repeat 0
	set banner_skip "(.*?($password_prompt)|($username_prompt)|($exec_prompt)|($enable_prompt)){$banner_skip_repeat}"
	set menuExit 30
	set menuPrompt Selection:
	set forceDisable "false"
	set use_securid "exec"
	set execAccessOnly "false"
	set useTruePrompt "false"
	set suspect_prompt #
	