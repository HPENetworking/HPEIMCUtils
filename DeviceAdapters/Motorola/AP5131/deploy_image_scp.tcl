
#**************************************************************************
# Identification:deploy_image_scp.tcl
# Purpose:       deploy image to device by scp
#**************************************************************************

set target_file "/os/primary"
if { [string first primary $slot] >= 0 } {
   set targetfile "/os/primary"
} else {
   set targetfile "/os/secondary"
}

set index1 [string last / $TFTPFile]
set len [string length $TFTPFile]
incr index1
set FileName [string range $TFTPFile $index1 $len]

set TFTPFileLocal [pwd]
append TFTPFileLocal "/../bin/"
append TFTPFileLocal $FileName

file copy -force $TFTPFile $TFTPFileLocal
	
if { $keyfile != "" } {
   spawn pscp -scp -i $keyfile $FileName $username@$deviceip:$targetfile 
} else {
   spawn pscp -scp $FileName $username@$deviceip:$targetfile 
}

set password_prompt "assword:|PASSCODE:"
set timeout 600

set loop true
while { $loop == "true" } {
	expect {
		-re $password_prompt {
			if {$password == "\x24password" || $password == ""} {
				set ERROR_MESSAGE "Missing password"
				set ERROR_RESULT true
				set loop false
				#exit
			} else {			    
			    send "$password"
			    sleep 1
				send "\r"
				
				set sent_password "true"
			}
		} "Press Y or ENTER to continue, N to exit" {
			send "Y"			
		} "Wrong password" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Wrong password."
			#exit
			set loop false
		} "Please press ENTER" {
			send "\r"
			set loop false
		} "Login failed" {
			# Failure ... get out
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Device rejected the username or password."
			#exit			
			set loop false
		} "Passphrase for key" {
			send "$passphrase\r"
		} -re "Store key in cache|Update cached key" {
			send "y\r"
		} "y/n" {
			send "y\r"
		} "Unable to use key file" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Unable to use key file."
			set loop false
		} "Network error" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Network error."
			set loop false
		} "Access denied" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Access denied."
			set loop false
		} "Authentication refused" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Authentication refused."
			set loop false
		} "FATAL ERROR:" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "FATAL ERROR."
			set loop false
		} "Fatal: Server unexpectedly closed network connection" {
		    #normal close connection
		    set loop false
		} "Server refused to start" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Fatal: Server refused to start a shell/command."
			set loop false
		} "Unable to load private key" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Unable to load private key."
			set loop false
		} "Server refused" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Server refused."
			set loop false
		} "Enter passphrase for key" {
			send "$passphrase\r"
		} "Are you sure you want to continue connecting" {
			send "yes\r"
		} "Permission denied" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Permission denied."
			set loop false
		} "Received disconnect" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Received disconnect."
			set loop false
		} "bad permissions" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "bad permissions."
			set loop false
		} "Identity file * not accessible:" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Identity file not accessible."
			set loop false
		} "Connection refused" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Connection refused."
			set loop false
		} "Connection timed out" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Connection timed out."
			set loop false
		} "connection is closed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "connection is closed."
			set loop false
		} "Connection closed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Connection closed."
			set loop false
		} "Write failed:" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Write failed: Broken pipe."
			set loop false
		} "Missing argument" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Missing argument."
			set loop false
		} "no authentication methods available" {
		#Bitvise
			set ERROR_RESULT  true
			set ERROR_MESSAGE "no authentication methods available."
			set loop false
		} "Authentication failed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Authentication failed."
			set loop false
		} "S/A/C" {
			send "S\r"
		} "assphrase:" {
			send "$passphrase\r"
		} "Too many authentication failures" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Too many authentication failures."
			set loop false
		} "Connection aborted" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Connection aborted."
			set loop false
		} "parameter failed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "parameter failed."
			set loop false
		} "Connection failed" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Connection failed."
			set loop false
		} "passphrase is invalid" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "passphrase is invalid."
			set loop false
		} "Server rejected" {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Server rejected."
			set loop false
		} "Login password has not been set" {
			# Failure ... get out
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Cannot login. Message from device: Login password has not been set!"
			set loop false
			#exit
		} "Error." {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Error."
			set loop false
		} "100%" {
		    #success 
		    sleep 10
		    set loop false
		} timeout {
			set ERROR_RESULT  true
			set ERROR_MESSAGE "Timeout to login. No message recive from device!"
			#exit
			set loop false
		}
	}
}

sleep 180
file delete -force $TFTPFileLocal
set timeout 10	