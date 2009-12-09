package Catalyst::Authentication::Credential::MockOpenID;
use strict;
use warnings;
use base qw/Catalyst::Authentication::Credential::OpenID/;

sub authenticate {
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

1;
