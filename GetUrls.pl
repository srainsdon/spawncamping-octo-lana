#!/usr/bin/perl -w
    use strict;
    use warnings;
    use Data::Dumper;
    use URI::Escape;
    
    my @set;
    my @array;
    my $num = 0;
    
sub ProssesUrl {
	my %Settings  = ();
	my ($VAR1) = @_;
	$VAR1 = uri_unescape($VAR1);
	$VAR1 = uri_unescape($VAR1);
	my @segments = split('\\\u0026', $VAR1);
	#print "$VAR1\n";
	#print Dumper(@segments);
	foreach my $setting (@segments) {
		next unless ($setting =~ m/=/);
		#my ($key, $vlaue) = split("=",$setting);
		my @KeyValue = $setting =~ qr/(.+?)=(.+)/;
		$Settings{$KeyValue[0]} = $KeyValue[1];
	}
	return \%Settings;
}
    
    my $filename = 'watch.htm';
    open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";
     
    while (my $row = <$fh>) {
	chomp $row;
	next unless ($row =~ m/adaptive_fmts/);
	#print "$row\n";
	@set = split ( ",", $row );
	#print join("\n", @set);
	}
    foreach my $line (@set) {
	next unless ($line =~ m/init=/);
	my @tmp = $line =~ q/init=(.+)/;
	$array[$num] = $tmp[0];
	#print $array[$num] . "\n";
	$num++;
	}
	#print Dumper(@array);
	foreach my $tmp (@array) {
		my $Settings = ProssesUrl($tmp);
		print Dumper($Settings);
	}