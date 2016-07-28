# 2920 ADP 

This folder contains the following files

- Aruba2920InitialConfig.cfg
- 2920_Final.cfg

## Notes

- ArubaOS switches are extremely sensitive to the contents of the startup.cfg file.
If a startup.cfg file contains invalid configurations, this may cause issues such as
the switch not accepting the configuration, or not loading the configuration at boot time.
As such, care should be taken to ensure that the configuration being deployed is
valid on the target device.

-The 2920 can be in stacking mode or single-unit mode. If the device is in
stacking mode, the interface labels will change, adding a %member__id%/%port_number%
to the initial port number

**ex. Interface 1 on stack member 2 would now be 2/1**
 
 You may use the **all** keyword on interface configurations to deal with this issue if applicable
 to the specific configuration you're trying to push out.
 