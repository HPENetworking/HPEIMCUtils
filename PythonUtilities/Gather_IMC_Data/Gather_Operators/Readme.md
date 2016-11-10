# Gather Configuration Templates

This script will export the operator list from the existing system into a csv file named
operators.csv.

The IMC API does not allow for all parameters to be exported so the following values must be filled in before importing
into the target system.

* fullName
* name
* desc
* authType
* operatorGroupId
* password
* defaultAcl
* sessionTimeout

The operatorGroupId represents the integer assigned to the operator within the IMC system
If using custom operator groups, ensure that the custom operator groups have been created before attempting 
to import operators assigned to those groups.

You will also have to adjust your import script to map the appropriate operator group
from the new system to the appropriate ID from the new system.