#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use HTTP::Request::Common;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

BEGIN {
    unless (
        eval { require Crypt::DH } &&
        eval { require Catalyst::Authentication::Credential::OpenID; }
    ) {
        plan skip_all => 'OpenID dependencies not installed';
    }
}

use Catalyst::Test 'TestAppOpenID';
my ($res, $c);

ok(request('/login')->is_success, 'Get /login');

($res, $c) = ctx_request(POST 'http://localhost/login', [ openid_identifier => 'aaa' ]);
is($res->code, 200, 'get login form');
ok( $res->content =~ /class="error_message">Invalid OpenID</, 'get errors in login form' );

($res, $c) = ctx_request(POST 'http://localhost/login', [ openid_identifier => 'http://mock.open.id.server' ]);
is($res->code, 302, 'get redirect to openid server');
is($res->header( 'location' ), 'http://localhost/login?openid-check=1', 'Redir location');
($res, $c) = ctx_request(POST 'http://localhost/login?openid-check=1', );
my $user = $c->user;
is( $user->{url}, 'http://mock.open.id.server', 'user url' );
is( $user->{display}, 'mocked_user', 'user display' );

done_testing;

