#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;

require '../config/db.pl';

my $r = new CGI;
my $j = new JSON;

db_connect();

my $data = ();
my $count = count_rows();

my $fetch = fetch_rows( $r->Vars );

while ( my $res = $fetch->() ) {
  push( @$data, $res );
}

print $r->header('application/json');
print $j->encode( { data => $data, count => $count } );
