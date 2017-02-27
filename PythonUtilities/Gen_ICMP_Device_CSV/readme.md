#Generate ICMP Device CSV

When installing IMC, it is very common to have multiple devices discovered as ICMP only devices ( Desktops ).  This can
be due to multiple reasons including

- SNMP unconfigured
- Wrong SNMP version
- Wrong SNMP credentials
- ACL blocking SNMP communications

Unfortunately, there's no magic way fix these problems.  Further investigation must be done to be able determine the nature 
of the communications issue and resolve it so that IMC can properly communicate with the device over SNMP.

The purpose of this script is to automatically generate an excel file ( CSV format ) which shoud contain all the necessary
information to help an infrastructure operator understand which devices are not currently configured with the proper management
credentials.


Information elements in the CSV may include:

- HostLabel:  The name of the ICMP device in IMC. This may also resolve to a DNS name.
- HostIp:  The IP address of the ICMP device as discovered in IMC.
- HostMac:  The MAC address of the ICMP device as discovered in IMC. 
- SwitchIp:  The IP address of the Switch which the ICMP device is connected to in IMC. 
- SwitchName: The name of the Switch which the ICMP device is connected to in IMC.
- SwitchType: The type of the Switch which the ICMP device is connected to in IMC.
- SwitchLocation: The location, as set in the SNMP syslocation, of the Switch which the ICMP device is connected to in IMC.
- SwitchContact: The contact, as set in the SNMP syscontact, of the Switch which the ICMP device is connected to in IMC.
- SwitchIntDesc: The interface description, if set, of the interface which the ICMP device is connected to in IMC.
- SwitchInt: The interface which the ICMP device is connected to in IMC.

 Variables in the CSV file may not populate for various reasons. This is normal.

## Note

It is assumed that the network is well desigend with a management IP address scope which is seperate from that of user devices.
If IMC has discovered the user device ICMP range, there will be many faulse devices which you likely don't want to manage.

One way of dealing with this problem is compare the generated CSV file with the DHCP scopes for those network segments.
