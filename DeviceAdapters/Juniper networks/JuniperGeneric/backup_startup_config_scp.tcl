
#**************************************************************************
# Identification:deploy_config_scp.tcl
# Purpose:       deploy config by scp
#**************************************************************************

<step>
	<action>open</action>
	<host>$host</host>
	<username>$username</username>
	<password>$password</password>
</step>

<step>
	<action>get</action>
	<transfermode>ascii</transfermode>
	<remote_file>rn_config</remote_file>
</step>

<step>
    <action>close</action>
</step>