#!/usr/bin/perl
use DBI;
use DBD::Pg;
use File::Basename;
use File::Slurp;
use YAML;
use utf8;
use JSON;

use Data::Dumper;

$main::dbh = '';

# init default table fields


# @main::fields = map { 'col_' . $_} ('a'..'c');
@main::fields = map { 'col_' . $_} ('a'..'t');
unshift( @main::fields, 'id' );

#
# perform db connection and sets and returns $main:dbh
# connection parameters read from database.yml file.
#

sub db_connect {
  eval {
    my $db_config = Load scalar read_file(dirname(__FILE__) . '/database.yml');
    my $db_conn_string = 'dbi:Pg:dbname=' . $db_config->{'database'} . 
      ';port=' . $db_config->{'port'} . 
      ';host=' . $db_config->{'host'};
    $main::dbh = DBI->connect_cached( $db_conn_string, $db_config->{'user'}, 
      $db_config->{'password'}, \%options);
    $main::dbh->do("SET CLIENT_ENCODING TO '" . $db_config->{'encoding'} . "'");
  };
  if($@) {
    die "HIBA: Adatbázishoz nem lehet csatlakozni! $@";
    return 'HIBA';
  } else {
    return $main::dbh;
  }
}

#
# creates a table.
# first parameter will be the table name.
#

sub create_db_table {
  my ($table) = @_;

  # drop table if exists
  $main::dbh->do("DROP TABLE IF EXISTS $table");

  # create database table with 20 fields
  my $q = "CREATE TABLE $table ( id SERIAL UNIQUE, ";
  foreach( 'a'..'t' ) {
    $q .= "col_$_ varchar(255),";
  }
  chop($q);
  $q .= ')';
  $main::dbh->do($q);
}

#
# populates a table with dummy datas.
# first parameter will be the table name.
#

sub populate_table {
  my $table = shift;

  my $file = '/usr/share/dict/words';
  open my $fh, '<', $file # ooh, it's a file access!
    or die("can't open $file for reading: $!");
  my @words = <$fh>;
  close $fh;
  chomp(@words);

  my $q = 'BEGIN;';
  foreach( 1..5000 ) {
    $q .= "\nINSERT INTO $table (";
    foreach( 'a'..'t' ) {
      $q .= "col_$_ ,";
    }
    chop($q);
 
    $q .=  ") VALUES (";
    foreach( 'a'..'t' ) {
      my $value = "$words[rand @words]";
      utf8::encode($value);
      $value =~ s/'/''/g;
      $value =~ s/\//'\//g;
      $q .= "'" . $value . ' ' . rand(@words) . "' ,";
    }
    chop($q);
    $q .= ');';
  }
  $q .= 'COMMIT;';
  my $pq = $main::dbh->prepare($q);
  $pq->execute();
}


#
# execute a simple query and returns the results in a hash.
# the hash key will be the column given in the sort parameter.
# Default parameters are:
# table => 'tbl_with_20_fields', start => 0
# example call: fetch_rows( { limit => 25 } )
#

sub fetch_rows {
  my %args = @_;
  my %defaults = ( table => 'tbl_with_20_fields', start => 0 );
  foreach (keys %defaults) {
    defined ($args{$_}) || {$args{$_}= $defaults{$_}} ;
  }
  
  my $q = 'SELECT '. join(', ', @main::fields) .' FROM ' . $args{table};
  
  if( defined %args->{'sort'} ) {
    my $sort = decode_json( %args->{'sort'} );
    $q .= ' ORDER BY ' . @{$sort}[0]->{'property'} . ' ' . @{$sort}[0]->{'direction'};
  }

  if( defined $args{limit} ) {
    $q .= ' LIMIT ' . $args{limit};
  }
  $q .= ' OFFSET ' . $args{start};

  $sth = $main::dbh->prepare( $q );
  $sth->execute();
  return sub { $sth->fetchrow_hashref() };
}

#
# returns the count of table rows
#

sub count_rows {
  my $table = shift || 'tbl_with_20_fields';
  my $q = 'SELECT COUNT (*) FROM ' . ${table};
  
  $sth = $main::dbh->prepare( $q );
  $sth->execute();
  my $count = $sth->fetch();
  return @{$count}[0];
}

1;
