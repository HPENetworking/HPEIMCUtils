# ArubaOS 

## Tested Platforms
These configurations have been provided for the following platforms

- 2920 J9727A - Single switch - non stacking
- 5400R J9850A - 5406R Platform


## ArubaOS Configurations

The ArubaOS devices requires that the configuration file contain a line with the "J"
number and some additional parameters in the startup config file.

>> ; J9850A Configuration Editor; Created on release #KB.16.01.0007

If the J number in the configuration does not match the J number of the device,
the device will refuse the configuration file.

For non-stackable or chassis platofrms, the **IGNORE** command can be used
to allow a single initial configuration file to be deployed to multiple device types
and models.

### Ignore Command

To deal with the issue above, the **IGNORE** command can be placed in the
initial configuration file to allow the switch to skip that line of the configuration

The IGNORE tag is inserted into the first line of the configuration file directly after the J-number.

At the time of this writting ( 07/28/2016 ), the **IGNORE** command is does 
*NOT* work with the stackable or chassis based platforms. Please refer to your product
documentation to see if there has been a change.


**Taken from the ArubaOS documentation**

>> 7.14.1 DHCP auto deployment
Auto deployment relies on DHCP options and the current DHCP auto-configuration function. Auto deployment is platform independent, avoiding the J-number validation of the downloaded configuration file when downloaded using DHCP option 66/67. The downloaded configuration file has an IGNORE tag immediately after the J-number in its header.

>> An option to add an add-ignore-tag to an existing copy command will insert an ignore tag into the configuration header. This insertion happens while transferring the configurations, (startup configuration files and running configuration files) from the switch to a configuration file setup on a remote server. The process uses TFTP/SFTP or can be accomplished with a serially connected workstation using XMODEM.

>> 7.14.2 Add-Ignore-Tag option
The add-ignore-tag option is used in conjunction with the copy command to transfer the startup configuration or running configuration files from the switch to a remote server with IGNORE tag inserted into it.

>> The IGNORE tag is inserted into the first line of the configuration file directly after the J-number.
; J9782A IGNORE Configuration Editor; Created on release #YB.15.14.0000x
; Ver #04:63.ff.37.27:88
hostname "HP-2530-24"
snmp-server community "public" unrestricted
vlan 1
name "DEFAULT_VLAN"
no untagged 2,20-25
untagged 1,3-19,26-28
ip address dhcp-bootp

>> NOTE: The J-number validation is ignored only when configuration file that contains the IGNORE tag is downloaded to a switch via DHCP option 66/67. When a configuration file containing the IGNORE tag is downloaded to a switch using CLI, SNMP or WebUI, the downloaded configuration file is only accepted if the J-number in it matches the J-number on the switch.