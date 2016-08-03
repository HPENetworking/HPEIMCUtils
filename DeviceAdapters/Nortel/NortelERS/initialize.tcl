
#**************************************************************************
# Identification:initialize
# Purpose:       initialize variables
#**************************************************************************

set standard_timeout 20
set long_timeout 60
set very_long_timeout 120
set very_very_long_timeout 300
set squeeze_timeout 300
set username_prompt "Enter Username:"
set password_prompt "Enter Password:"
set exec_prompt >
set enable_prompt #
set config_prompt )#
set config_promptRE \)\#
set enforce_save true
set timeout $standard_timeout
set more_prompt "----More"
set pause $more_prompt
set sent_password "false"
set useTruePrompt "false"

set ERROR_RESULT false
set ERROR_MESSAGE ""
