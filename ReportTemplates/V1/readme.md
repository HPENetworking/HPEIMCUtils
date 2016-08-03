# iAR report template V1 (means made with Crystal Reports)

- Perf_Availability_SLA.rpt : Gives an overview of the availability of the devices with SLA. 
		I converted unavailability index to availability
		SLA (% of availability) are put in the parameters "Warning thresholds", "Major Thresholds" and "Critical".
		I also added the concept of "Open hours" (begin and end) so that the report only include the data between these two times
		I made pattern matching to identify "Category" and "Branch Code" based on the device name. The pattern is the following: <Category Name>-<Device Name>-<Branch Code>
		
		
