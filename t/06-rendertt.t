#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Test 'TestAppRenderTT';
my ($res, $c);

ok(request('/')->is_success, 'Get /');
ok(request('/login')->is_success, 'Get /login');
is(request('/logout')->code, 302, 'Get 302 from /logout');

($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 'aaaa']);
is($res->code, 200, 'get errors in login form');
like($c->res->body, qr/Wrong username or password/, 'login error');


($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 's00p3r']);
my $cookie = $res->header('Set-Cookie');
($res, $c) = ctx_request(GET 'http://localhost/', Cookie => $cookie);
ok( ($c->session_expires-time()-7200) <= 0, 'Session length low when no "remember"');
($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 's00p3r', remember => 1]);
$cookie = $res->header('Set-Cookie');
is($res->code, 302, 'get 302 redirect');
is($res->header('Location'), 'http://localhost/', 'Redirect to /');
($res, $c) = ctx_request(GET 'http://localhost/', Cookie => $cookie);
ok( ($c->session_expires-time()-7200) >= 0, 'Long session set when "remember"');
$cookie = $res->header('Set-Cookie');
ok($cookie, 'Have a cookie');
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

done_testing;
