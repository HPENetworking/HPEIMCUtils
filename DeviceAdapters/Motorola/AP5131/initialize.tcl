set standard_timeout 10
set long_timeout 120
set very_long_timeout 1800
set username_prompt ogin:
set password_prompt assword:
set login_as "ogin as:"
set info_prompt "continue!"
set orig_exec_prompt ">"
set orig_enable_prompt ">"
set exec_prompt ">"
set system_prompt "system)>"
set fwupdate_prompt "system.fw-update)>"
set enable_prompt $exec_prompt
set timeout $standard_timeout

set ERROR_RESULT false
set ERROR_MESSAGE ""
set send_slow {1 0.2}