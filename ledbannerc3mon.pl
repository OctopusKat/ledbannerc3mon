#!/usr/bin/perl

use strict;
use warnings;
use JSON qw( decode_json );
use File::Fetch;

# Grab the latest stats from c3netmon and decode the data
my $statsjson = File::Fetch->new(uri => 'http://c3netmon.camp.ohm2013.org/current.json');

print $statsjson;
my $decoded = decode_json($statsjson);


# Pulling out the shadow temprature from the decoded json
print "Shadow temprature: " . $decoded->{'OHM1'}{'value'} . "\n";
