package CatalystX::SimpleLogin::Form::LoginOpenID;
use HTML::FormHandler::Moose::Role;

use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;

has_field 'openid_identifier' => ( type => 'Text' );
has_field 'openid-check' => ( widget => 'no_render' );

has 'openid_error_message' => (
    is => 'ro',
    isa => NonEmptySimpleStr,
    required => 1,
    default => 'Invalid OpenID',
);

after 'add_auth_errors' => sub {
    my $self = shift;
    $self->field( 'openid_identifier' )->add_error( $self->openid_error_message ) 
      if $self->field( 'openid-check' )->value or defined $self->field( 'openid_identifier' )->value;
};

1;

