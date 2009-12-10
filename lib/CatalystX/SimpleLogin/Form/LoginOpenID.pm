package CatalystX::SimpleLogin::Form::LoginOpenID;
use HTML::FormHandler::Moose::Role;

use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;

BEGIN {
    unless (
        eval { require Crypt::DH } &&
        eval { require Catalyst::Authentication::Credential::OpenID; }
    ) {
        warn("Cannot load " . __PACKAGE__ . " - Catalyst OpenID authentication credential not installed\n");
        exit 1;
    }
}

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

=head1 NAME

CatalystX::SimpleLogin::Form::LoginOpenID - OpenID validation role for the login form

=head1 DESCRIPTION

A L<HTML::FormHandler> role form for the login form.

=head1 FIELDS


=over

=item openid_identifier

=item openid-check

=item openid_error_message

=back

=head1 METHODS

=over

=item add_auth_errors

=back

=head1 SEE ALSO

=over

=item L<CatalystX::SimpleLogin::ControllerRole::Login>

=back

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut

