# Notes on ArubaOS Autodeployment

Taken from the ArubaOS docuemntation

7.14.1 DHCP auto deployment
Auto deployment relies on DHCP options and the current DHCP auto-configuration function. Auto deployment is platform independent, avoiding the J-number validation of the downloaded configuration file when downloaded using DHCP option 66/67. The downloaded configuration file has an IGNORE tag immediately after the J-number in its header.

An option to add an add-ignore-tag to an existing copy command will insert an ignore tag into the configuration header. This insertion happens while transferring the configurations, (startup configuration files and running configuration files) from the switch to a configuration file setup on a remote server. The process uses TFTP/SFTP or can be accomplished with a serially connected workstation using XMODEM.

7.14.2 Add-Ignore-Tag option
The add-ignore-tag option is used in conjunction with the copy command to transfer the startup configuration or running configuration files from the switch to a remote server with IGNORE tag inserted into it.

The IGNORE tag is inserted into the first line of the configuration file directly after the J-number.
; J9782A IGNORE Configuration Editor; Created on release #YB.15.14.0000x
; Ver #04:63.ff.37.27:88
hostname "HP-2530-24"
snmp-server community "public" unrestricted
vlan 1
name "DEFAULT_VLAN"
no untagged 2,20-25
untagged 1,3-19,26-28
ip address dhcp-bootp

NOTE: The J-number validation is ignored only when configuration file that contains the IGNORE tag is downloaded to a switch via DHCP option 66/67. When a configuration file containing the IGNORE tag is downloaded to a switch using CLI, SNMP or WebUI, the downloaded configuration file is only accepted if the J-number in it matches the J-number on the switch.
