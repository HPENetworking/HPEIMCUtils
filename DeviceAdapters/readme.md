# Device Adapters


Collection of custom adapters

In this directory you will find a collection of custom adapters which enhance the support of IMC in term of configuration / software management (backup, restore, deploy ...).

For more information regarding creating or editing custom device adapters, please see the HPE IMC Platform Administrators guide for your specific version.

Device adapters included here do not necessarily support all IMC Configuration Center functionality and may only support a subset of functionality.

## Working with Device Adapters

1) Copy the folder into the \imc\server\conf\adapters\icc folder

2) Create the Device Vendor, Device Series, and Device Models for the device you're working with.

* Note: The Device Vendor name you created in the IMC platform **MUST** be identical to the name of the device adapter base folder in the ICC directory.

3) Restart IMC Server

4) Discover the new devices.



The device adapter is bound to the device at time of initial discovery, if you had previously discovered the device, you may need to delete and rediscover the device.





