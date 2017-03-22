#! /usr/local/bin/perl

sub cleanupImageVersion
{
	#Image             Size (bytes) Date     Version 
	#----------------- ------------ -------- --------------
	#Primary Image    :    10267410 06/07/12 YA.15.10             
	#Secondary Image  :    10267410 06/07/12 YA.15.10            

	#Boot ROM Version : YA.15.12
	#Default Boot     : Primary
	
	my($config) = @_;
	my($boot) = "";
	my($key) = "";

	if ($config =~ m/Default Boot.*:\s+(\S+)/) {
		$boot = $1;
	}
	if ($boot eq "Primary") {
		$key = "Primary Image";
	}
	if ($boot eq "Secondary") {
		$key = "Secondary Image";
	}
	if ($config =~ m/$key.*:\s+\S+\s+\S+\s+(\S+)/) {
		my $version = $1;
		return $version;
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
	$rawdata =~ s/-- MORE --.*Control-C//g;

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

	$start = 0;
	if($config =~ /(Startup|Running) +configuration:\s*/gc)
	{
		$start = pos($config);
	}

	$stop = -1;
	$pos = -1;

	$cleanConfig = substr($config, $start);
	$cleanConfig = removeMores($cleanConfig);
	$cleanConfig = stripLastLine($cleanConfig);

	return $cleanConfig . "\n\n"; # Add a newline to match TFTP configuration
}

sub cleanupTFTPConfiguration
{
	my($config) = @_;

	$start = 0;
	if($config =~ /(Startup|Running) +configuration:\s*/gc)
	{
		$start = pos($config);
	}

	return substr($config, $start);
}

sub cleanupVersion
{
	my($rawdata) = @_;

	$start = 0;
	if($rawdata =~ /(Image stamp:)/gc)
	{
		$start = pos($rawdata) - length($1);
	}
	$rawdata = substr($rawdata, $start);
	$cleandata = removeMores($rawdata);
	$cleandata = stripLastLine($cleandata);

	return $cleandata;
}