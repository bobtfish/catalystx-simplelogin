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
is($res->header('Location'), 'http://localhost/login', 'Redirect to /login');
my $cookie = $res->header('Set-Cookie');
ok($cookie, 'Have a cookie');
($res, $c) = ctx_request(GET 'http://localhost/login', Cookie => $cookie);
like($c->res->body, qr/Please Login to view this Test Action/, 'check for custom login msg');