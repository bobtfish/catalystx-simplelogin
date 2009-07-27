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

($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 'aaaa']);
is($res->code, 200, 'get errors in login form');
like($c->res->body, qr/Wrong username or password/, 'login error');
like($c->res->body, qr/submit/, 'submit button on form');

($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 's00p3r']);
ok( ($c->session_expires-time()-7200) <= 0, 'Session length low when no "remember"');
($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 's00p3r', remember => 1]);
TODO: {
    local $TODO = "Session expiry doesn't work";
ok( ($c->session_expires-time()-7200) >= 0, 'Long session set when "remember"');
}
is($res->code, 302, 'get 302 redirect');
my $cookie = $res->header('Set-Cookie');
ok($cookie, 'Have a cookie');
is($res->header('Location'), 'http://localhost/', 'Redirect to /');
ok($c->user, 'Have a user in $c');

($res, $c) = ctx_request(GET 'http://localhost/', Cookie => $cookie);
like($c->res->body, qr/Logged in/, 'Am logged in');

($res, $c) = ctx_request(GET 'http://localhost/logout', Cookie => $cookie);
is($res->code, 302, '/logout with cookie redirects');
is($res->header('Location'), 'http://localhost/', 'Redirect to / after logout');
ok($res->header('Set-Cookie'), 'Cookie is reset by /logout');

($res, $c) = ctx_request(GET 'http://localhost/', Cookie => $cookie);
ok($res->is_success, '/ success');
unlike($c->res->body, qr/Logged in/, 'Am logged out');

