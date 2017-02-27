#! /usr/local/bin/perl

sub cleanupPartionName
{
	my($config) = @_;

	# CLI sometimes leaks in some syslog messages.. remove them _first_ [important]
	$config =~ s/(^|\n)\%.*//g; 

    #response is:
    #Directory of flash:/
    #-rwxrwxrwx   1 noone    nogroup      2785  Apr 04 2000 01:55:25   vrpcfg.txt
    #-rwxrwxrwx   1 noone    nogroup   1973145  Apr 23 2000 17:57:22   S2000-VRP310-R0023P01-h3c.app
    #3381248 bytes total (1402880 bytes free)
    #<Quidway>
    
	my $key_ = "Directory of";
    my $pos_       = index ( $config, $key_, 0 );
    if ($pos_ != -1) {
    	my $start_ = $pos_ + length $key_;	    	
    	$config = substr( $config, $start_+1);
    	
    	$key_ = "\n";
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

    #response is:
    #Directory of flash:/
    #-rwxrwxrwx   1 noone    nogroup      2785  Apr 04 2000 01:55:25   vrpcfg.txt
    #-rwxrwxrwx   1 noone    nogroup   1973145  Apr 23 2000 17:57:22   S2000-VRP310-R0023P01-h3c.app
    #3381248 bytes total (1402880 bytes free)
    #<Quidway>
    
	my $key_ = "total (";
    my $pos_       = index ( $config, $key_, 0 );
    if ($pos_ != -1) {
    	my $start_ = $pos_ + length $key_;	    	
    	$config = substr( $config, $start_ );
    	
    	$key_ = "KB free";
    	$pos_       = index ( $config, $key_, 0 );
    	if ($pos_ != -1) {    		
    		$config = substr( $config, 0, $pos_);
    	}
    	
    	$config =~ s/[\r\n ]//g;
    	$config = 1024*$config;
    	return $config;
    }    
    
    return "-1";
}

sub cleanupBoardNumber
{
	my($config) = @_;
	    
    #remove syslog
	$config =~ s/(^|\n)\%.*//g; 

    #The primary app to boot of board 5 at this time is: flash:/s7500e-v6r6b2d088.app
    #The primary app to boot of board 0 at this time is: flash:/s7600_v8r1_rmi-63sp18.app
    
	my $key_ = "The primary app to boot of board";
    my $pos_       = index ( $config, $key_, 0 );
    if ($pos_ != -1) {
    	my $start_ = $pos_ + length $key_;	    	
    	$config = substr( $config, $start_+1);
    	
    	$key_ = "at this time";
    	$pos_       = index ( $config, $key_, 0 );
    	if ($pos_ != -1) {    		
    		$config = substr( $config, 0, $pos_);
    	}
    	
    	$config =~ s/[\r\n ]//g;	    	
    	return $config;
    }    
		
	return 0;
}

sub cleanupImageSize
{
	my($config) = @_;

	# cmd resp is as follow:
	#<iCC>dir cf:/msr50-cmw520-r1618p14-h3c.bin
    #Directory of cf:/
    #
    #0     -rw-  13994404  May 20 2010 16:49:16   msr50-cmw520-r1618p14-h3c.bin
    #
    #252908 KB total (230988 KB free)
    #
    #File system type of cf: FAT16
    #
    #<iCC>
    
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
	my($config) = @_;

	# CLI sometimes leaks in some syslog messages.. remove them _first_ [important]
	$config =~ s/(^|\n)\%.*//g; 

	$image_position =  removeMores($config);
	$image_position =~ s/pwd\n//;
	$image_position =  stripLastLine($image_position);
    $image_position =~ s/[\r\n ]//g;
	
	return $image_position;
}

sub cleanupImageVersion
{
	my($rawdata) = @_;

	# Remove the first line [command], along with more prompts and the last line [prompt]
	$cleandata =  removeMores($rawdata);
	$cleandata =~ s/^.*\n//;
	$cleandata =  stripLastLine($cleandata);
	
	#Boot file on flash is: flash:/ar28v300r003b04d032.bin
    $key_ = "Boot file on flash is";
	$pos_       = index ( $cleandata, $key_, 0 );
    if ($pos_ != -1) { 
        my $cleandata_ = substr( $cleandata, $pos_, (length $cleandata) - $pos_); 	
       	my $start_ = index( $cleandata_, "/",0 );	
    	my $end_ = length $cleandata_;
    	$cleandata_ = substr( $cleandata_, $start_+1, $end_ - $start_ -1);
    	$cleandata_ =~ s/[\r\n ]//g;
    	return $cleandata_;
    }
    
    #The boot file used at this reboot:cf:/msr50-cmw520-r1618p14-h3c.bin attribute:main
    my $key_ = "The boot file used at this reboot";
    my $pos_       = index ( $cleandata, $key_, 0 );
    if ($pos_ != -1) {
    	my $start_ = index($cleandata, "/",$pos_ + length $key_);	
    	my $end_ = index($cleandata,"attribute",$start_ + 1);
    	
    	$cleandata = substr( $cleandata, $start_+1, $end_ - $start_ -1);
    	$cleandata =~ s/[\r\n ]//g;
    	return $cleandata;
    }
    
    #The boot file used this time:cf:/mainar29.bin attribute: main
    $key_ = "The boot file used this time";
    $pos_       = index ( $cleandata, $key_, 0 );
    if ($pos_ != -1) {
    	my $start_ = index($cleandata, "/",$pos_ + length $key_);	
    	my $end_ = index($cleandata,"attribute",$start_ + 1);
    	
    	$cleandata = substr( $cleandata, $start_+1, $end_ - $start_-1);
    	$cleandata =~ s/[\r\n ]//g;
    	return $cleandata;
    }
	
	#The current boot app is: s4c03_03_01s168p04.app
	#The current boot app is: flash:/s3610-cmw520.bin
	$key_ = "The current boot app is:";
	$pos_       = index ( $cleandata, $key_, 0 );
    if ($pos_ != -1) {    
        my $start_ = index($cleandata, "/",$pos_ + length $key_);	
        if ($start_ == -1) {	    	
    	   $start_ = $pos_ + length $key_;
    	}
    	my $end_ = index($cleandata,"\n",$start_ +1);
    	$cleandata = substr( $cleandata, $start_ +1, $end_ - $start_ -1);    	
    	$cleandata =~ s/[\r\n ]//g;
    	return $cleandata;
    }
    
	#The primary app to boot of board 5 at this time is: flash:/s7500e-cmw520-e6611.app
	$key_ = "The primary app to boot of board";
	$pos_       = index ( $cleandata, $key_, 0 );
    if ($pos_ != -1) {    	
       	my $start_ = index($cleandata, "/",$pos_ + length $key_);	
    	my $end_ = index($cleandata,$key_,$start_ +1);
    	$cleandata = substr( $cleandata, $start_ +1, $end_ - $start_-1);
    	$cleandata =~ s/[\r\n ]//g;
    	return $cleandata;
    }
    
    return $cleandata;
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

	# For some reason, if a line that's longer than the terminal width immediately preceeds a "more"
	# break,... the device duplicates the latter half of the string in the following line. We need
	# to clean this up, risky though it may be
	
	# Split on the possible more prompts [to remove them]
	@lines = split( /----More \(q\=Quit, space\/return=Continue\)----/, $rawdata );

	foreach $line (@lines) {

		# Each section starts with multiple "^H ^H" [was part of the more prompt]... remove them
		$line =~ s/^(\cH \cH)+//;

		# If the more is directly followed by a full-length line, then the following line
		# will be duplicated... weird side-effect of MOREing combined with terminal wrapping
		$line =~ s/(.{132})\n(.*)/$1/ge;

		# Fix the other wrapped lines in this segment
		$line =~ s/(.{132})\n/$1/ge;
	}

	# Put the line sections back together
	$rawdata = join( "", @lines );

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

sub decodeBinary
{
	my($binaryConfig) = @_;
	
	# decode binary config
	my $str = $binaryConfig;

	$str =~ tr|A-Za-z0-9+=/||cd;		# remove non-base64 chars
	if (length($str) % 4) 
	{
		my $errtxt = "Length of base64 data not a multiple of 4";
		print "$errtxt\n";
	}
	$str =~ s/=+$//;			# remove padding
	$str =~ tr|A-Za-z0-9+/| -_|;		# convert to uuencoded format
	if (!(length $str))
	{
		my $errtxt = "String blank";
		print "$errtxt\n";
		die errtxt;
	}

	my $uustr = "";
	my $l = length($str) - 60;
	my $i;
	for ($i = 0; $i <= $l; $i += 60) 
	{
		$uustr .= "M" . substr($str, $i, 60);
	}
	$str = substr($str, $i);

	# and any leftover chars
	if ($str ne "") 
	{
		$uustr .= chr(32 + length($str)*3/4) . $str;
	}

	$binaryConfig = unpack ("u", $uustr);

	## BINARY CONFIG DECODED
	return $binaryConfig;
}

sub getChecksum
{
	my($binaryConfig) = @_;

	while($binaryConfig =~ /(.)/g)
	{
		$checksum += ord($1);
		if($checksum > 1000000)
		{
			$checksum %= 1000000;
		}
	}

	return $checksum;
}

sub cleanupConfiguration
{
	my($rawdata, $binaryConfig) = @_;
	
	# Split the text from the binary configuration
	if ($rawdata =~ /{result=([\S\s]+), binary_configuration\=([\S\s]+)}$/) {
		$cleanConfig  = $1;
	} else {
		$cleanConfig = $rawdata;
	}
	
	# Remove the leading commands up until the "show running-config"
	$cleanConfig =  removeMores( $cleanConfig );
	$cleanConfig =~ s/([\S\s]+?show running-config\n)//;
	$cleanConfig =  stripLastLine( $cleanConfig );
	$cleanConfig =~ s/\s+$//;

	# Add the checksum to the text configuration
	if ($binaryConfig) {
		$binaryConfig = decodeBinary( $binaryConfig );
		$checksum     = getChecksum ( $binaryConfig );

		$cleanConfig = "# Binary configuration captured, checksum: $checksum\n# Device's text version of configuration follows\n#-----------------------------------------------------\n$cleanConfig";
	}
	
	return $cleanConfig;
}

sub cleanupTFTPConfiguration
{
	my($rawdata, $binaryConfig) = @_;

	# Split the text from the binary configuration
	if ($rawdata =~ /{result=([\S\s]+), binary_configuration=([\S\s]+)}$/) {
		$cleanConfig  = $1;
	} else {
		$cleanConfig = $rawdata;
	}

	# Remove three comment lines from the beginning of the file and
	# three lines from the end ... not presentin the CLI scrape
	$cleanConfig =~ s/\! NOTE.*\n! +It is noted at the end.*\n\! +is the case.*\n//;
	$cleanConfig =~ s/\n\!\n\! ACG configuration generation completed\n\!\n*//;
	$cleanConfig =~ s/\s+$//;

	# Add the checksum to the text configuration
	if ($binaryConfig) {
		$binaryConfig = decodeBinary( $binaryConfig );
		$checksum     = getChecksum ( $binaryConfig );

		$cleanConfig = "# Binary configuration captured, checksum: $checksum\n# Device's text version of configuration follows\n#-----------------------------------------------------\n$cleanConfig";
	}
	
	return $cleanConfig;
}