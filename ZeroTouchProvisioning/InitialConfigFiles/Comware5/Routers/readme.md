#HPE Comware5 based Routers

This configuration was deployed to an HPE MSR 930 router.

To ensure the zero-touch provisioning would work from the routed interface, all bridged interfaces had to be disconnected. 





##Documentation Reference

Taken from the following document
http://h20565.www2.hpe.com/hpsc/doc/public/display?sp4ts.oid=4176157&docId=emr_na-c02659468&docLocale=en_US


Automatic configuration works in the following manner:

1. During startup, the device sets the first up interface (if up Layer 2 Ethernet interfaces exist, the VLAN
interface of the default VLAN of the Ethernet interfaces is selected as the first up interface. Otherwise,
the up Layer 3 Ethernet interface with the smallest interface number is selected as the first up interface)
as the DHCP client to request parameters from the DHCP server, such as an IP address and name of a
TFTP server, IP address of a DNS server, and the configuration file name.

2. After getting related parameters, the device sends a TFTP request to obtain the configuration file from
the specified TFTP server and executes the configuration file. If the client cannot get such parameters,
it uses factory default configuration.
To implement automatic configuration, you must configure the DHCP server, DNS server, and TFTP server, but
you do not need to perform any configuration on the device performing automatic configuration. The
configuration of these servers varies with device models and is omitted.
Before starting the device, connect only the interface needed in automatic configuration to the network.

