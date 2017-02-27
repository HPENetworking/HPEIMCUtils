
#**************************************************************************
# Identification:initialize
# Purpose:       initialize variables
#**************************************************************************
   
    set env(TERM) vt100
    set standard_timeout 10
    set long_timeout 120
    set long_long_timeout 300
    set very_long_timeout 1800
    set squeeze_timeout 2400
    set username_prompt "sername:|ogin:"
    set password_prompt "assword:|nter PASSCODE:"
    set enable_password_prompt "assword:|PASSCODE:"
    set next_passcode_prompt "tokencode:|ext PASSCODE:"
    set orig_exec_prompt ">"
    set orig_enable_prompt "#"
    set exec_prompt ">"
    set enable_prompt "#"
	set menuPrompt "#"
    set config_prompt "(config)#"
    set enforce_save false
    set timeout $standard_timeout
    set more_prompt --More--
    set pause $more_prompt
    set sent_password "false"
    set banner_skip_repeat 0
    set banner_skip "(.*?($password_prompt)|($username_prompt)|($exec_prompt)|($enable_prompt)){$banner_skip_repeat}"
    #value to use to exit login menu (if it exists)
    set menuExit 30
    #prompt to expect to identify a login menu
    set use_undeterministic_prompt "undeterministic prompt is not in use"
    set tc_undeterministic_prompt "(\\S\\S\\S.+)\\$"
    set runningConfig "running-config"
    set startupConfig "startup-config"

    set setBootImage "true"
    set setOSImage "true"
    
    #add other variables
    set ERROR_RESULT false
    set ERROR_MESSAGE ""
    
    set suspect_prompt #
    set next_passcode $password
    set securid_enable_passcode $enable_password
    set securid_enable_next_passcode $enable_password

    set skip_ctrl_u true
    set use_securid "exec"
    set forceDisable "false"
    set useTruePrompt "false"
    set resetMorePrompting "false"
    set execAccessOnly "false"
    set tarAutoExtracted "false"
    set isC3750 "false"
    set isC3560 "false"
    set deletebins "false"
    set bootvalue "false"
    set cannotSqueeze "true"
    set verifyImage "false"