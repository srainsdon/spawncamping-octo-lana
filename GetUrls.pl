#!/usr/bin/perl -w
    use strict;
    use warnings;
    use Data::Dumper;
    use URI::Escape;
    use LWP::Simple;

    my @set;
    my @array;
    my $num = 0;
    
sub ProssesSettings {
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

sub ProssesUrl {
	my %Settings  = ();
	my ($VAR1) = @_;
	my @UrlSetting = $VAR1 =~ qr/videoplayback?(.+)/;
	my @segments = split('&', @UrlSetting);
	#print "$VAR1\n";
	#print Dumper(@segments);
	foreach my $setting (@segments) {
		next unless ($setting =~ m/=/);
		#my ($key, $vlaue) = split("=",$setting);
		my @KeyValue = $setting =~ qr/(.+?)=(.+)/;
		$Settings{$KeyValue[0]} = $KeyValue[1];
	}
	return %Settings;
}

sub GetFileYT { # youtube url as input
	my($Url) = @_;
	my $page = get $Url;
	my @Lines = split("\n", $page);
	my $UrlSetings;
	foreach my $row (@Lines) {
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
			my $Settings = ProssesSettings($tmp);
			print Dumper($Settings);
			if (exists $Settings->{'size'} && $Settings->{'url'}) {
				if ($Settings->{'size'} eq'1920x1080') {
					print "url: " . $Settings->{'url'} . "\n";
					my %UrlSettings = ProssesUrl($Settings->{'url'});
					print Dumper(%UrlSettings);
					#getstore($Settings->{'url'}, );
				}
			} else { return 0; }
	}
	return 1;
}
# GetFileYT("http://www.youtube.com/watch?v=YLx7g4XThW4");
my $DiditWork = 0;
while (1) {
$DiditWork = GetFileYT("http://www.youtube.com/watch?v=YLx7g4XThW4");
if ($DiditWork == 1) {
last;
}
}