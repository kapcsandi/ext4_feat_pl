#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;

my $r = new CGI;

print $r->header('text/html'),
  $r->start_html(
    -encoding => 'UTF-8',
    -lang => 'hu-HU',
    -title => 'test 1, task-2',
    -script => [
      {
        -type => 'text/javascript',
        -src => '/ext-4.0.0/ext-all.js'
      },
      {
        -type => 'text/javascript',
        -src => '/js/app.js'
      }
    ],
    -style => [
      {
        -type => 'text/css',
        -src => '/ext-4.0.0/resources/css/ext-all.css'
      },
      {
        -type => 'text/css',
        -src => '/css/app.css'
      }
    ]
  ),
  $r->h1('Test 1, Task 2'),
  $r->div({-id=> 'grid'}, '');

print $r->end_html();
