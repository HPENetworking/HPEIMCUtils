
#**************************************************************************
# Identification:initialize
# Purpose:       initialize variables
#**************************************************************************

set standard_timeout 10
set long_timeout 60
set very_long_timeout 120
set username_prompt login:
set password_prompt assword:
set orig_exec_prompt ->
set exec_prompt ->
set enforce_save false
set timeout $standard_timeout
set more_prompt "--- more ---"
set pause $more_prompt
set page_size 22
set banner_skip_repeat 0
set TFTPInterface ""
#set banner_skip "([\s\S]*?($password_prompt)|($username_prompt)|($exec_prompt)){$banner_skip_repeat}"
# Reset this custom variable if it's not set
#if {$TFTPInterface == "\x24TFTPInterface"} {
#    set TFTPInterface " "
#}