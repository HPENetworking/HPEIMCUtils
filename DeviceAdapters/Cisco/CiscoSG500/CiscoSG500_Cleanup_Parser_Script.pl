#! /usr/local/bin/perl

sub cleanupPartionName
{
	 my($config) = @_;

	 # CLI sometimes leaks in some syslog messages.. remove them _first_ [important]
	 $config =~ s/(^|\n)\%.*//g; 

   $config =~ m/Directory of (\S+:)/;
		
   $config = "$1:";    	
   return $config;    
    
   return "/";
}

sub cleanupFreeSize
{
		my($config) = @_;
		# CLI sometimes leaks in some syslog messages.. remove them _first_ [important]
	  $config =~ s/(^|\n)\%.*//g; 

	  $config =~ m/(\d+)$/;
    $config = "$1:";

    return $config;    
   
    return "-1";
}

