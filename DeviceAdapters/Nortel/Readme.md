# Some Nortel adapters

I made some correction / addition in the existing Nortel adapters.

Please add the following lines in adapter-index.xml in Nortel directory:

        <adapter name="BayStack425">
    		<description>Nortel BaysStack 425 series (Fabien GIRAUD home made)</description>
            <sysoid>1.3.6.1.4.1.45.3.57.1</sysoid>
         </adapter>
		 
Don't forget to restart the following IMC porcess after copying / editing adapters:
imccmdmgrdm, imccfgbakdm, and imcupgdm 