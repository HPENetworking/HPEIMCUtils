# HPE IMC Zero Touch Provisioning

HPE IMC Base platform contains a features called *Auto Deployment Plan* which allows operators to take a network infrastructure device out of the box and ensure that it's in the desired state before it gets on the network.

The process works as follows


1. Operator sets DHCP option 66 ( IMC TFTP Server )and DHCP option 67 intial configuration file name
2. Operator plugs device into VLAN where DHCP is provided with option 66 and option 67
3. Device contacts IMC TFTP server and requests the filename as learned from DHCP 67
4. IMC contacts device at source IP of TFTP request using default credentials from initial config file
5. IMC attempts to match device to a defined list of devices in the auto-deployment plan **a csv file can be used to import the list**
6. If a match occurs, IMC will push settings defined in the ADP list to the device. 


## CSV File

A sample of the CSV file can be found in this folder called *HomeLab.csv*

## Initial Configuration Files

Initial Configuration Files for Various Vendors and Operating systems can be found in the corresponding directories.

**Note: Initial Config files credentials *must* match the credentials in the ADP initial config dialog. These credentials may change as new version of HPE IMC are released.
Please verify that the credentials match in the *Service > Configuration Center > Auto Deployment Plan > Initial Configuration File Management* page of the HPE IMC Server**

Initial config files have been provided for 

- HPE ArubaOS Devices
- Cisco IOS
- HPE Comware5 Devices
- HPE Comware7 Devices
