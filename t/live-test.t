#!/usr/bin/env perl

use strict;
use warnings;
use Test::More 'no_plan';
use HTTP::Request::Common;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Test 'TestApp';
my ($res, $c);

ok(request('/')->is_success, 'Get /');
ok(request('/login')->is_success, 'Get /login');
is(request('/logout')->code, 302, 'Get 302 from /logout');

($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 's00p3r']);
is($res->code, 302, 'get 302 redirect');
is($res->header('Location'), 'http://localhost/', 'Redirect to /');
ok($c->user, 'Have a user in $c');

