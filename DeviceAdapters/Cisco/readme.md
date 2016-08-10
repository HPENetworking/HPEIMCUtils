
# A Cisco Adapter                                                       #
#########################################################################
Import those lines into your adapter-index.xml in the Cisco Root Directory:
#

        <adapter  name="CiscoSG500">
                <description>Cisco SG 500 LineUp</description>
		<sysoid>1.3.6.1.4.1.9.6.1.85.16.7</sysoid>
        </adapter>
        
#	
Don't forget to restart the following IMC process after copying / editing adapters:
imccmdmgrdm, imccfgbakdm, and imcupgdm 
