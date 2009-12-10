#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Test 'TestAppRedirect';

foreach my $path (qw|needslogin needslogin_chained needslogin_chained_subpart|) {
    my ($res, $c) = ctx_request(GET "/$path");
    is($res->code, 302, 'get 302 redirect for /' . $path);
    is($res->header('Location'), 'http://localhost/login', 'Redirect to /login');
    ok(!$res->header('X-Action-Run'), 'Action shouldnt run! ' . ($res->header('X-Action-Run')||''));
}
{
    my ($res, $c) = ctx_request(GET "/needslogin_chained_subpart");
    ok($res->header('X-Start-Chain-Run'), 'Start of chain actions run when needslogin at end of chain');
}

{
    my ($res, $c) = ctx_request('/needslogin');
    my $cookie = $res->header('Set-Cookie');
    ok($cookie, 'Have a cookie');
    ($res, $c) = ctx_request(POST '/login', [username => 'bob', password => 's00p3r'], Cookie => $cookie);
    is($c->session->{redirect_to_after_login}, 'http://localhost/needslogin', '$c->session->{redirect_to_after_login} set');
    ok($c->user, 'Have a user in $c');
    is($res->code, 302, 'get 302 redirect to needslogin');
    is($res->header('Location'), 'http://localhost/needslogin', 'Redirect to /needslogin');
    ($res, $c) = ctx_request(GET '/needslogin', Cookie => $cookie);
    is($res->code, 200, 'get 200 ok for page which needs login');
}

done_testing;

