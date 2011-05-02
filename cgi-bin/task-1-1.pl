#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;
use CGI::Carp qw(warningsToBrowser fatalsToBrowser); 

require '../config/db.pl';

my $r = CGI->new;

print $r->header('text/html');

print 'Connect to database.<br />';
db_connect();

my $table = 'tbl_with_20_fields';

print "Create database table $table.<br />";
create_db_table($table);

print "Populate database table.<br />";
populate_table($table);

print 'Done.';

print $r->end_html();