#!/usr/bin/perl

use strict;
use warnings;
use JSON qw( decode_json );
use LWP;
use LWP::UserAgent;
use LWP::Simple;
use URI::Escape;

while (1) {

	print "Requesting JSON... ";

	# Grab the latest stats from c3netmon and decode the data
	my $statsjson = get 'http://c3netmon.camp.ohm2013.org/current.json';
	my $decoded = decode_json($statsjson);
	print "Ok, it's " . $decoded->{'OHM1'}{'value'}[0] . "°C (" . ($decoded->{'OHM1'}{'value'}[0]+273) . " K)\n";

	# Pulling out the shadow temprature from the decoded json
	my $bannerstr = "Temperature: " . ($decoded->{'OHM1'}{'value'}[0]+273) . " K (" . $decoded->{'OHM1'}{'value'}[0] . " C)\n";

	# Create a user agent object
	my $ua = LWP::UserAgent->new;
	$ua->agent("https://github.com/OctopusKat/ledbannerc3mon/");

	my $req = HTTP::Request->new(POST => 'http://ledbanner.ip6.nl/cgi-bin/ledbanner.cgi');
	$req->content_type('application/x-www-form-urlencoded');
	$req->content('text='.uri_escape($bannerstr));

	print "Sending temperature stats to LED banner... ";

	# Pass request to the user agent and get a response back
	my $res = $ua->request($req);

	# Check the outcome of the response
	if ($res->is_success) {
	    print "Success!\n\n";
	} else {
	    print $res->status_line, "\n";
	}
	
	sleep 60;

        print "Requesting JSON... ";

        # Grab the latest stats from c3netmon and decode the data
        $statsjson = get 'http://c3netmon.camp.ohm2013.org/current.json';
        $decoded = decode_json($statsjson);
	print "Ok, Down: " . $decoded->{'bw'}{'value'}[0] . " Mb/s (" . int($decoded->{'bw'}{'value'}[0]/100.0 + 0.5) . "%)    Up: " . $decoded->{'bw'}{'value'}[1] . " Mb/s (" . int($decoded->{'bw'}{'value'}[1]/100.0 + 0.5) . "%)";

        # Pulling out the shadow temprature from the decoded json
        $bannerstr = "Down: " . $decoded->{'bw'}{'value'}[0] . " Mb/s (" . int($decoded->{'bw'}{'value'}[0]/100.0 + 0.5) . "%)     Up: " . $decoded->{'bw'}{'value'}[1] . " Mb/s (" . int($decoded->{'bw'}{'value'}[1]/100.0 + 0.5) . "%)\n";

        # Create a user agent object
        $ua = LWP::UserAgent->new;
        $ua->agent("https://github.com/OctopusKat/ledbannerc3mon/");

        $req = HTTP::Request->new(POST => 'http://ledbanner.ip6.nl/cgi-bin/ledbanner.cgi');
        $req->content_type('application/x-www-form-urlencoded');
        $req->content('text='.uri_escape($bannerstr));

        print "Sending Bandwidth stats to LED banner... ";

        # Pass request to the user agent and get a response back
        $res = $ua->request($req);

        # Check the outcome of the response
        if ($res->is_success) {
            print "Success!\n\n";
        } else {
            print $res->status_line, "\n";
        }

        sleep 60;

}
