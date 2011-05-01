#!/usr/bin/perl -w
use strict;
use warnings;

require '../config/db.pl';

print "Content-type: text/html\r\n\r\n";
print "\n";

print 'Connect to database<br />';
db_connect();

my $table = 'tbl_with_20_fields';

print "Create database table $table<br />";
create_db_table($table);

print "Populate database table<br />";
populate_table($table);

print 'Done.';
