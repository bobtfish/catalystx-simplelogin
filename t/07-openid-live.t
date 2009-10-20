#!/usr/bin/env perl

use strict;
use warnings;
use Test::More 'no_plan';
use HTTP::Request::Common;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Authentication::Credential::OpenID;
use Test::MockModule;
my $module = new Test::MockModule('Catalyst::Authentication::Credential::OpenID');
$module->mock('authenticate', \&authenticate_mock);

sub authenticate_mock {
    my ( $self, $c, $realm, $authinfo ) = @_;
    my $claimed_uri = $authinfo->{ 'openid_identifier' };
    if ( $claimed_uri ) {
        if( $claimed_uri eq 'aaa' ){
            return;
        }
        if( $claimed_uri eq 'http://mock.open.id.server' ){
            $c->res->redirect( 'http://localhost/login?openid-check=1' );
            $c->detach();
        }
    }
    elsif ( $c->req->params->{'openid-check'} ){
        my $user = {
            url => 'http://mock.open.id.server' ,
            display => 'mocked_user' ,
            rss => '',
            atom => '',
            foaf => '',
            declared_rss => '',
            declared_atom => '',
            declared_foaf => '',
            foafmaker => '',
        };
        return $realm->find_user($user, $c);
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

