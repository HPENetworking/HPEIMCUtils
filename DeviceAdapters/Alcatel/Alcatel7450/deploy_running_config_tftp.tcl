
#**************************************************************************
# Identification:deploy_running_config_tftp
# Purpose:       deploy running configuration by tftp
#**************************************************************************

	set timeout $very_long_timeout
	set WARNING_RESULT true
	
	# Copy the file to the device
	send "file copy tftp://$TFTPServer/$TFTPFile NAStemp\r\n"
	expect {
		"(y/n)?" {
			# File exists... perhaps we didn't clean up last time
			send "y\r\n"
			expect $enable_prompt
		} $enable_prompt {
		}
	}

	# Execute the script file
	send "exec NAStemp\r\n"
	expect {
		"failed" {
			set ERROR_RESULT true
			set ERROR_MESSAGE "Merge of configuration script failed; review session log to locate failing command(s)."
			expect $enable_prompt
		} -re "Executed \S+ lines in \S+ seconds" {
			expect *
			
			# Success -- prompt may have changed -- reset TruePrompt variables
			set -f enable_prompt "#"
			set -f exec_prompt "#"
			expect $enable_prompt
		}
	}

	# Delete the temporary file
	send "file delete NAStemp\r\n"
	expect {
		"(y/n)?" {
			# Confirm deletion
			send "y\r\n"
			expect $enable_prompt
		} $enable_prompt {
		}
	}
		
	if { $ERROR_RESULT != "true" &amp;&amp; $ERROR_NONFATAL != "true" } {
		set -f WARNING_RESULT false

		set -f enable_prompt "#"
		set -f exec_prompt "#"
		
		# We're in enable mode -- ensure that changes are saved
		# Note: prompt contains a leading asterisk if it has been changed, which will
		# disappear after we save. Revert to _orig_ prompt to ensure correct operation.
		send "admin save\r\n"
		expect $enable_prompt
	}
    set timeout $standard_timeout