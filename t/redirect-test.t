#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 8;
use HTTP::Request::Common;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Test 'TestAppRedirect';
my ($res, $c);

($res, $c) = ctx_request(GET 'http://localhost/needslogin');
is($res->code, 302, 'get 302 redirect for page which needs login');
is($res->header('Location'), 'http://localhost/login', 'Redirect to /login');
my $cookie = $res->header('Set-Cookie');
ok($cookie, 'Have a cookie');
($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 's00p3r'], Cookie => $cookie);
is($c->session->{redirect_to_after_login}, 'needslogin', '$c->session->{redirect_to_after_login} set');
ok($c->user, 'Have a user in $c');
is($res->code, 302, 'get 302 redirect to needslogin');
is($res->header('Location'), 'http://localhost/needslogin', 'Redirect to /needslogin');
($res, $c) = ctx_request(GET 'http://localhost/needslogin', Cookie => $cookie);
is($res->code, 200, 'get 200 ok for page which needs login');

