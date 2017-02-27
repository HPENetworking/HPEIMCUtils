# Gather IMC Data


Occasionally, I get asked if it's possible to backup and restore only certain components of the IMC configuration.

The DBMAN backup/restore process does a full backup and restore of the entire IMC system data, including all historical data.

It is not uncommon to want to grab configuration items only and transfer them to a new system. Although this is not possible
in the system itself, we can use the API to pull the desired data from the old system and export it into a format which can be 
pushed through the API into the target system.

This section contains a set of scripts which will gather the following data
Work in progress. If there are specific requests, please open up an Issue and we'll try and get to it sooner
-  Custom Views
-   List of Installed Devices
- Configuration Templates
- Custom Performance Indices
- Device Groups
- Operators
- Operator Groups
- Port Groups
- SNMP Templates
- Telnet Templates
- SSH Templates