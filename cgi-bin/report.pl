#!/usr/bin/perl -w
use strict;
use warnings;
use Spreadsheet::SimpleExcel;

require '../config/db.pl';

db_connect();
my $fetch = fetch_rows();

my @header = @main::fields;

#
foreach( @header ) {
  s/_/\ /;
  s/(\w+)/\u\L$1/g;
}

my @data;

#
while ( my $res = $fetch->() ) {
  my @row = ( delete(%{$res}->{'id'}) );

  foreach my $key (sort keys( %$res )) {
    push( @row, %{$res}->{$key} );
  }
  push( @data, \@row );
}

#
my $excel = Spreadsheet::SimpleExcel->new();

#
$excel->add_worksheet('Report',{-headers => \@header, -data => \@data});

print "content-type: application/vnd.ms-excel\n"; 
print "content-disposition: attachment; filename=report.xls\n\n";

#
$excel->output_to_file('-');
