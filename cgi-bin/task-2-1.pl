#!/usr/bin/perl -w
use strict;
use warnings;
use CGI;

my $r = new CGI;

print $r->header('text/html'),
  $r->start_html(
    -encoding => 'UTF-8',
    -lang => 'hu-HU',
    -title => 'task-2-1',
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
  $r->h1('Test 2, Task 1'),
  $r->div({-id=> 'toolbar'}, ''),
  $r->div({-id=> 'page'}, ''),
  $r->div({-id=> 'xhr'}, '');

print $r->end_html();
