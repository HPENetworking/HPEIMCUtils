# Checking Interface VLAN Config

In large installations, it is common for "cookie-cutter" installations which require identical configurations to be deployed to
devices in multiple configurations.

The provided script provides automated reporting for the following use case

There is a large deployment with an HPE 5406R switch in each site.  

There is an IP phone at each site which must be plugged into interface A17.

Port A17 must be an untagged VLAN ( access interface ) with the PVID 2 configured as it's untagged VLAN.

This script will perform the following

- Gather all the 5406Rs that are discovered in IMC into a list
- For each switch in the list do the following
--  Gather the interface name
--	Gather the interface description
--	Make sure it’s an access port ( untagged )
--	Make sure the PVID of the port is vlan 2
Append each result into as a python dictionary into a list object 
-	Write the list object into an excel spreadsheet ( csv )


