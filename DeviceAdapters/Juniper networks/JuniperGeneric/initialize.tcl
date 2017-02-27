
#**************************************************************************
# Identification:initialize
# Purpose:       initialize variables
#**************************************************************************

set standard_timeout 12
set long_timeout 120
set very_long_timeout 1800
set very_very_long_timeout 2400
set squeeze_timeout 15000

set username_prompt login:
set password_prompt "assword:|nter PASSCODE:"
set next_passcode_prompt "tokencode:|ext PASSCODE:"
set orig_exec_prompt >
set orig_enable_prompt #
set exec_prompt >
set enable_prompt #
set shell_prompt %
set config_prompt "edit]"
set config_filename rn_config
set enforce_save true
set timeout $standard_timeout
set more_prompt {---.more}
set pause $more_prompt
set sent_password "false"
set banner_skip_repeat 0
set banner_skip {(($password_prompt)|($username_prompt)|($exec_prompt)|($enable_prompt)){$banner_skip_repeat}}
set error_pattern {((Unknown|syntax error).*)}
set delete_files "true"
set delete_everything "false"
set use_securid "exec"
set next_passcode " "
set useTruePrompt "false"
set resetMorePrompting "true"
set ERROR_RESULT ""
