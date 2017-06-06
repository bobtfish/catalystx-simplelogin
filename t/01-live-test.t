#!/usr/bin/env perl

use strict;
use warnings;
use Test::More 'no_plan';
use HTTP::Request::Common;
use File::Path;
use Path::Class;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Test 'TestApp';
my ($res, $c);

ok(request('/')->is_success, 'Get /');
ok(request('/login')->is_success, 'Get /login');
is(request('/logout')->code, 302, 'Get 302 from /logout');

is(request('/needsauth')->code, 302, 'Get 302 from /needsauth');

($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 'aaaa']);
is($res->code, 200, 'get errors in login form');
like($c->res->body, qr/Wrong username or password/, 'login error');
like($c->res->body, qr/submit/, 'submit button on form');

($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 's00p3r']);
is($res->code, 302, 'get 302 redirect');
my $cookie = $res->header('Set-Cookie');
ok($cookie, 'Have a cookie');
is($res->header('Location'), 'http://localhost/', 'Redirect to /');
ok($c->user, 'Have a user in $c');
($res, $c) = ctx_request(GET 'http://localhost/', Cookie => $cookie);
like($c->res->body, qr/Logged in/, 'Am logged in');
ok( $c->session_is_valid, 'Session is valid');
ok( ($c->session_expires && $c->session_expires-time()-7200) <= 0, 'Session length low when no "remember"');

($res, $c) = ctx_request(GET 'http://localhost/logout', Cookie => $cookie);
ok(!$c->user_exists, 'No user in $c after logout');

($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 's00p3r', remember => 1], Cookie => $cookie);
my ($session_id) = $cookie=~/testapp_session=(.*?);/;
$cookie = $res->header('Set-Cookie');
my ($new_session_id) = $cookie=~/testapp_session=(.*?);/;
isnt $session_id, $new_session_id, 'Session id should have changed.';
($res, $c) = ctx_request(GET 'http://localhost/', Cookie => $cookie);
ok( (($c->session_expires-time()-7200)       > 0) &&
    (($c->session_expires-time()-1000000000) < 0) , 'Long session set when "remember"');

$cookie = $res->header('Set-Cookie');
ok($cookie, 'Have a cookie');
ok($c->user_exists, 'have the user back after re-login with "remember"');

($res, $c) = ctx_request(GET 'http://localhost/logout', Cookie => $cookie);
$cookie = $res->header('Set-Cookie');
my ($new_new_session_id) = $cookie=~/testapp_session=(.*?);/;
isnt $new_new_session_id, $new_session_id, 'Check session id changed when we logged out';
$cookie = $res->header('Set-Cookie');
ok(!$c->user_exists, 'No user in $c after logout from long session');
$cookie = $res->header('Set-Cookie');

($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 's00p3r'], Cookie => $cookie);
$cookie = $res->header('Set-Cookie');
($res, $c) = ctx_request(GET 'http://localhost/', Cookie => $cookie);
ok( ($c->session_expires && $c->session_expires-time()-7200) <= 0, 'Session length is low again when no "remember"');

$res = request(GET 'http://localhost/needsauth', Cookie => $cookie);
is($res->code, 200, '/needsauth 200OK now');

($res, $c) = ctx_request(GET 'http://localhost/logout', Cookie => $cookie);
is($res->code, 302, '/logout with cookie redirects');
is($res->header('Location'), 'http://localhost/', 'Redirect to / after logout');
ok($res->header('Set-Cookie'), 'Cookie is reset by /logout');

($res, $c) = ctx_request(GET 'http://localhost/', Cookie => $cookie);
ok($res->is_success, '/ success');
unlike($c->res->body, qr/Logged in/, 'Am logged out');
rmtree( dir( TestApp->_session_file_storage->{_Backend}{_Root} )->parent->parent , { } );
