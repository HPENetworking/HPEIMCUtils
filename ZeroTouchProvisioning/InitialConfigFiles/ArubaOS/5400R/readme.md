# 5400 ADP 

This folder contains the following files

- 0InitialConfig.cfg
- 5400R_Final.cfg

## Notes

- ArubaOS switches are extremely sensitive to the contents of the startup.cfg file.
If a startup.cfg file contains invalid configurations, this may cause issues such as
the switch not accepting the configuration, or not loading the configuration at boot time.
As such, care should be taken to ensure that the configuration being deployed is
valid on the target device.

- The 5400R is a chassis switch and can contain multiple modules which are defined by the
**module A type j9536a** command in the configuration file. When deploying a final configuration 
module definitions *must* be in the configuration file if an interface on a specific module
 is referenced anywhere in the configuration. 
 
  You may use the **all** keyword on interface configurations to deal with this issue if applicable
 to the specific configuration you're trying to push out.
 
 - If a **module** statement does not exist for a module that is currently installed in the
 chassis, the switch will accept the configuration and automatically detect the "new" module
 upon reboot
 
 - If a **module** statement exists for a module which does not physically exist in the
 chassis, the switch will accept the configuration.
  
  - if a **module** statement exist for a module, but does not match the specific **type**
  that is physically in the chassis, the switch will leave the definition as the wrong module type in
  the configuration