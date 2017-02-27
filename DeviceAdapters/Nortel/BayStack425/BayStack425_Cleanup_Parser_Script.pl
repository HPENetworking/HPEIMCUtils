#! /usr/local/bin/perl

sub getDiag
{
    my($rawdata) = @_;
    my $testvalue = "false";

    if($rawdata =~ /diag/) {
        $testvalue = "true"
    }

    return $testvalue;
}
