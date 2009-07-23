#!/usr/bin/env perl

use strict;
use warnings;
use Test::More 'no_plan';
use HTTP::Request::Common;
use Data::Dumper;
# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Test 'TestAppRedirect';
my ($res, $c);

($res, $c) = ctx_request(GET 'http://localhost/needslogincustommsg');
like($c->res->body, qr/Please Login to view this Test Action/, 'check for custom login msg');
#like($c->stash, qr/Please Login to view this Test Action/, 'check for custom login msg');
warn 'Stash:'.Dumper($c->stash)."\n";
warn 'Flash:'.Dumper($c->flash)."\n";
warn 'Session:'.Dumper($c->session)."\n";
warn 'Body:'.Dumper($c->res->body)."\n";



