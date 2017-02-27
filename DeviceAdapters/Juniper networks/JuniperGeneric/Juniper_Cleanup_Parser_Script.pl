#! /usr/local/bin/perl


sub cleanupPartionName
{
	my($rawdata) = @_;

	# Remove the first line [command], along with more prompts and the last line [prompt]
	$cleandata =  removeMores($rawdata);
	$cleandata =~ s/^.*\n//;
	$cleandata =  stripLastLine($cleandata);
    
    if ($cleandata =~ m/\/var/) {
            return "/var/tmp";
    }
    
    return "/";

}

sub cleanupFreeSize
{
	my($config) = @_;

	# CLI sometimes leaks in some syslog messages.. remove them _first_ [important]
	$config =~ s/(^|\n)\%.*//g; 

    #response is:
    #Filesystem              Size       Used      Avail  Capacity   Mounted on
    #/dev/ad0s1a             885M       158M       655M       19%  /
    #devfs                   1.0K       1.0K         0B      100%  /dev
    #devfs                   1.0K       1.0K         0B      100%  /dev/
    #/dev/ad0s1e              98M        20K        90M        0%  /config
    #procfs                  4.0K       4.0K         0B      100%  /proc
    #/dev/ad1s1f              16G       1.3G        14G        8%  /var

    #split to lines
    my $freeSize = -1;
    my @lines = split /^/,$config;
    for $i (0..$#lines) {
        if ($lines[$i] ne "") {
            my @columns = split " ",$lines[$i];
            if ($columns[5] eq "/var") {
                if ($columns[3] =~ /(.+)([GMKB])/) {
                    if ($2 eq "G") {
                        $freeSize = $1 * 1024 * 1024 * 1024;
                    } elsif ($2 eq "M")  {
                        $freeSize = $1 * 1024 * 1024;
                    } elsif ($2 eq "K")  {
                        $freeSize = $1 * 1024;
                    } else {
                        $freeSize = $1;
                    }
                }
            }
        }
    }
    if ($freeSize > 4294967295) {
        $freeSize = 4294967295;
    }
    return $freeSize;
}

sub cleanupImageSize
{
	my($config) = @_;

	# cmd resp is as follow:
	#dir bootflash:cat4000-i5s-mz.122-20.EWA-icc.bin
    #Directory of bootflash:/cat4000-i5s-mz.122-20.EWA-icc.bin
    #
    # 1  -rwx    12468240  May 19 2010 08:48:09 +00:00  cat4000-i5s-mz.122-20.EWA-icc.bin
    #
    #61341696 bytes total (48872396 bytes free)
    #
    #Switch#
    
    #remove syslog
	$config =~ s/(^|\n)\%.*//g; 

	my $key_ = "-rw-";
    my $pos_       = index ( $config, $key_, 0 );
    if ($pos_ != -1) {
    	my $start_ = $pos_ + length $key_;	    	
    	$config = substr( $config, $start_+1);
    	$config =~ s/\s+//; 
    	
    	$pos_ = index ( $config, " ", 0 );
    	$config = substr( $config, 0, $pos_);
    	$config =~ s/\s+//g; 
     	print "\n",$config;  	    	
    	return $config;
    }
    
    $key_ = "-rwx";
    $pos_       = index ( $config, $key_, 0 );
    if ($pos_ != -1) {
    	my $start_ = $pos_ + length $key_;	    	
    	$config = substr( $config, $start_+1);
    	$config =~ s/\s+//; 
    	
    	$pos_ = index ( $config, " ", 0 );
    	$config = substr( $config, 0, $pos_);
    	$config =~ s/\s+//g; 
     	print "\n",$config;  	    	
    	return $config;
    }
		
	return -1;
}

sub cleanupImagePosition
{
	my($rawdata) = @_;

	# Remove the first line [command], along with more prompts and the last line [prompt]
	$cleandata =  removeMores($rawdata);
	$cleandata =~ s/^.*\n//;
	$cleandata =  stripLastLine($cleandata);
    
    if ($cleandata =~ m/\/var/) {
        print "adfaf";
            return "/var/tmp";
    }
    
    return "/";
}

sub cleanupImageVersion
{
	my($rawdata) = @_;
	
	# Remove the first line [command], along with more prompts and the last line [prompt]
	$cleandata =  removeMores($rawdata);
	$cleandata =~ s/^.*\n//;
	$cleandata =  stripLastLine($cleandata);

    if ($cleandata =~ m/JUNOS Base OS boot \[(.+)\]/) {
        return $1;
    }
    
    return "";
}


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
	$rawdata =~ s/ ?---\(more\)--[ \S]*[\s\cH]+\cH//g;

	return $rawdata;
}

sub stripLastLine
{
	my($rawdata) = @_;

	@lines = split('\n', $rawdata);

	$#lines--;

	my($cleandata) = "";
	my($linecount) = 0;
	foreach $line (@lines)
	{
		if ($linecount == $#lines)
		{
			$cleandata .= "$line";
		}
		else
		{
			$cleandata .= "$line\n";
		}
		$linecount++;
	}

	while ($cleandata =~ /\n$/)
	{
		$cleandata =~ s/\n$//g;
	}

	return $cleandata;
}

sub cleanupConfiguration
{
	my($config) = @_;
	my(@array) = ();

	$start = index($config, "version");
	if ($start == -1)
	{
		$start = 0;
	}
	$cleanConfig = substr($config, $start);
	$cleanConfig = removeMores($cleanConfig);
	$cleanConfig = stripLastLine($cleanConfig);

	return $cleanConfig . "\n";
}