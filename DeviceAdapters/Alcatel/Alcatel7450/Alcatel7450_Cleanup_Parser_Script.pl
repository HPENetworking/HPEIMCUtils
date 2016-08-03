#! /usr/local/bin/perl

sub stripCarriageReturns
{
	my($rawdata) = @_;

	$rawdata =~ s/[\r\x80\xC0]//g;

	return $rawdata;
}

sub removeMores
{
	my($rawdata) = @_;

	$rawdata = stripCarriageReturns($rawdata);
    # match this more string with the CustomActions and ICMP cleanup parser
	$rawdata =~ s/Press any key to continue \(Q to quit\)\x0\xd +\xd//g;

	return $rawdata;
}

sub stripLastLine
{
	my($rawdata) = @_;

	$rawdata =~ s/\n+$//;
	$rawdata =~ s/\n[\S ]*?$//;
	$rawdata =~ s/\n+$//;
	
	return $rawdata;
}

sub cleanupConfiguration
{
	my($config) = @_;

	my $cleanConfig = removeMores($config);
	$cleanConfig =~ s/admin display-config.*\n//;
	$cleanConfig = stripLastLine($cleanConfig);

	# Remove generation datetime and exec end datetime
	$cleanConfig =~ s/.*Finished .*\n//g;
	$cleanConfig =~ s/.*Generated .*\n//g;
	

	# Add blank line to agree with tftp configuration
	$cleanConfig .= "\n";

	return $cleanConfig;
}

sub cleanupPartionName
{
	my($config) = @_;

	# CLI sometimes leaks in some syslog messages.. remove them _first_ [important]
	$config =~ s/(^|\n)\%.*//g; 

    #Listing Directory flash:/:
    #d  S       2048 Jan 12 1980 23:57 Boot/
    #d  S       2048 Jan  1 1980 00:00 Etc/
    #d  SH      2048 Jan  1 1993 04:42 Hidden/
	#-           107 Jan  1 1993 00:01 profile.cfg
	#-         43796 Aug 13 2013 17:48 dflt_startup_bin.cfg
	#-         11118 Aug 13 2013 18:04 dflt_startup.cfg
    #	Free disk space 2592768
    
	my $key_ = "Listing Directory";
    my $pos_       = index ( $config, $key_, 0 );
    if ($pos_ != -1) {
    	my $start_ = $pos_ + length $key_;	    	
    	$config = substr( $config, $start_);
    	
    	$key_ = "/";
    	$pos_       = index ( $config, $key_, 0 );
    	if ($pos_ != -1) {    		
    		$config = substr( $config, 0, $pos_);
    	}
    	
    	$config =~ s/[\r\n ]//g;
    	return $config;
    }    
    
    return "/";
}

sub cleanupFreeSize
{
	my($config) = @_;

	# CLI sometimes leaks in some syslog messages.. remove them _first_ [important]
	$config =~ s/(^|\n)\%.*//g; 
	
	
	#Listing Directory flash:/:
    #d  S       2048 Jan 12 1980 23:57 Boot/
    #d  S       2048 Jan  1 1980 00:00 Etc/
    #d  SH      2048 Jan  1 1993 04:42 Hidden/
	#-           107 Jan  1 1993 00:01 profile.cfg
	#-         43796 Aug 13 2013 17:48 dflt_startup_bin.cfg
	#-         11118 Aug 13 2013 18:04 dflt_startup.cfg
    #	Free disk space 2592768
    
	if($config =~m/Free disk space (\d+)/) {
        $config = $1;
        return $config;
    }
    
    return "-1";
}

