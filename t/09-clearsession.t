#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use LWP::UserAgent;
use HTTP::Request::Common;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Test 'TestAppClearSession';

####################################################################
# This test will is here to see if 'clear_session_on_logout' works.#
####################################################################
#   __PACKAGE__->config('Controller::Login' => { clear_session_on_logout => 1 });
####################################################################

# Can we request the index of the correct test app?..
my ($res, $c) = ctx_request(GET "/");
like($c->res->body, qr/BLARRRMOO/, '');

# Can we request that something be set in the session?..
($res, $c) = ctx_request(GET "/setsess");
is($res->code, 200, 'Set session requested (not logged in)');

# Did we get a cookie?..
my $cookie = $res->header('Set-Cookie');
ok($cookie, 'Got cookie - 001');

# Is there something in the session?..
($res, $c) = ctx_request(GET '/viewsess', Cookie => $cookie);
like($c->res->body, qr/session_var1_set=someval1/, '');

# Can we request that something else be set in the session .... even thou we have not yet logged in? 
#... should not be able to as this action 'NeedsLogin'...
($res, $c) = ctx_request(GET "/needsloginsetsess", Cookie => $cookie );
is($res->code, 302, 'Set session requested (logged in) ... we are not yet logged in');

# Can we login?...
($res, $c) = ctx_request(POST 'login', [ username => 'william', password => 's3cr3t' ], Cookie => $cookie );
is($res->code, 302, 'Logged in so therefore got 302 redirect');

# Is there still something in the session?..
($res, $c) = ctx_request(GET '/viewsess', Cookie => $cookie);
like($c->res->body, qr/session_var1_set=someval1/, '');

# Can we request that something else be set in the session now we are logged in?..
($res, $c) = ctx_request(GET "/needsloginsetsess", Cookie => $cookie );
is($res->code, 200, 'Set session requested (logged in)');

# Is there something new in the session?..
($res, $c) = ctx_request(GET '/viewsess', Cookie => $cookie);
like($c->res->body, qr/session_var2_set=someval2/, '');

# Can we logout?..
($res, $c) = ctx_request(GET 'logout', Cookie => $cookie );
is($res->code, 302, 'Logged out so therefore got 302 redirect');

# Ensure we are logged out, by requesting something at 'NeedsLogin'..
($res, $c) = ctx_request(GET "/needsloginsetsess", Cookie => $cookie );
is($res->code, 302, 'Set session requested (logged in)');

# Now lets have look at the session.. it should be clear..
# Is there something new in the session?..
($res, $c) = ctx_request(GET '/viewsess', Cookie => $cookie);
like($c->res->body, qr/In the session::/, 'Should be seeing a cleared session');

done_testing;

