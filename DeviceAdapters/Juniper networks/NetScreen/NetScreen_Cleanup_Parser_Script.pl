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

sub cleanupCLIConfiguration
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