#!/usr/bin/env perl

use strict;
use warnings;
use Test::More 'no_plan';
use HTTP::Request::Common;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

use Net::OpenID::Consumer;
use Test::MockModule;
my $module = new Test::MockModule('Net::OpenID::Consumer');
$module->mock('claimed_identity', \&claimed_identity_mock );
$module->mock('verified_identity', \&verified_identity_mock);

sub verified_identity_mock {
    my ( $self, ) = @_;
    return Mocked::Net::OpenID::Identity->new;
}

sub claimed_identity_mock {
    my ( $self, $url ) = @_;
    if( $url eq 'aaa' ){
        return;
    }
    if( $url eq 'http://mock.open.id.server' ){
        return Mocked::Net::OpenID::Identity->new;
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

{
    package Mocked::Net::OpenID::Identity;

    sub new { return bless {}, 'Mocked::Net::OpenID::Identity' };
    sub set_extension_args { warn 'set_extension_args' };
    sub check_url { 'http://localhost/login?openid-check=1' };

    sub url { 'http://mock.open.id.server' }
    sub display { 'mocked_user' }
    sub rss {}
    sub atom {}
    sub foaf {}
    sub declared_rss {}
    sub declared_atom {}
    sub declared_foaf {}
    sub foafmaker {}
}
