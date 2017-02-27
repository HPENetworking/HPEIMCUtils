
#**************************************************************************
# Identification:backup_image_scp.tcl
# Purpose:       retrieve image or file from device via SCP
#**************************************************************************

<step>
	<action>open</action>
	<host>$host</host>
	<username>$username</username>
	<password>$password</password>
</step>

<step>
	<action>get</action>
	<local_path>$TFTPPath</local_path>
	<local_file>$TFTPFile</local_file>
	<transfermode>binary</transfermode>
	<remote_file>$TFTPFile</remote_file>
</step>

<step>
	<action>close</action>
</step>