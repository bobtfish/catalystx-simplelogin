package CatalystX::SimpleLogin::TraitFor::Controller::Login::OpenID;
use MooseX::MethodAttributes ();
use Moose::Role -traits => 'MethodAttributes';
use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;
use namespace::autoclean;

has 'openid_realm' => (
    is => 'ro',
    isa => NonEmptySimpleStr,
    required => 1,
    default => 'openid',
);

# FIXME - Check that the configured auth realm exists in BUILD

around 'login_GET' => sub {
    my $orig = shift;
    my $self = shift;
    my ( $c ) = @_;

    if($c->req->param("openid.mode")) {
        if ($c->authenticate( {}, $self->openid_realm ) ) {
            $c->flash(success_msg => "You signed in with OpenID!");
            $c->res->redirect($self->redirect_after_login_uri($c));
        }
        else {
            $c->flash(error_msg => "Failed to sign in with OpenID!");
        }
    }
    else {
        return $self->$orig(@_);
    }
};

1;

=head1 NAME

CatalystX::SimpleLogin::TraitFor::Controller::Login::OpenID - allows a User to login via OpenID

=head1 SYNOPSIS

    # Turn on in config
    MyApp->config('Contoller::Login' => { traits => 'OpenID' });

=head1 DESCRIPTION

Provides the C<login>
action with a wrapper to handle OpenID logins.

-head1 WRAPPED METHODS

=head2 login_GET

FIXME


=head1 SEE ALSO

=over

=item L<CatalystX::SimpleLogin::ControllerRole::Login>

=item L<CatalystX::SimpleLogin::Form::Login>

=back

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut

