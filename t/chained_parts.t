#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Test 'TestApp';
my ($res, $c);

ok(request('/')->is_success, 'Get /');
ok(request('/login')->is_success, 'Get /login');
is(request('/chainedexample')->code, 302, 'Get 302 from /chainedexample');
is(request('/chainedexample/foo')->code, 302, 'Get 302 from /chainedexample/foo');

($res, $c) = ctx_request(GET 'http://localhost/chainedexample/public');
like($c->res->body, qr/page is public/, 'Public page is public.');

($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 's00p3r']);
is($res->code, 302, 'get 302 redirect');
my $cookie = $res->header('Set-Cookie');
ok($cookie, 'Have a cookie');
ok($c->user, 'Have a user in $c');

($res, $c) = ctx_request(GET 'http://localhost/chainedexample', Cookie => $cookie);
like($c->res->body, qr/Welcome bob/, 'Am logged in');
($res, $c) = ctx_request(GET 'http://localhost/chainedexample/foo', Cookie => $cookie);
like($c->res->body, qr/bob you inputted foo/, 'Works for sub path');

done_testing;
