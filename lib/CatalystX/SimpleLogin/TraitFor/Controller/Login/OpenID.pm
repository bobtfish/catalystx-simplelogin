package CatalystX::SimpleLogin::TraitFor::Controller::Login::OpenID;

use MooseX::MethodAttributes ();
use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;
use Moose::Role -traits => 'MethodAttributes';
use namespace::autoclean;

has 'openid_realm' => (
    is => 'ro',
    isa => NonEmptySimpleStr,
    required => 1,
    default => 'openid',
);

around 'login_GET' => sub  {
    my $orig = shift;
    my $self = shift;
    my ( $c) = @_;

    if($c->req->param("openid.mode"))
    {
        if($c->authenticate({},$self->openid_realm)) {
            $c->flash(success_msg => "You signed in with OpenID!");
            $c->res->redirect($self->redirect_after_login_uri($c));
        }
        else
        {
            $c->flash(error_msg => "Failed to sign in with OpenID!");
        }
    }
    else 
    {
        return $self->$orig(@_);
    }
};

=head1 NAME

CatalystX::SimpleLogin::TraitFor::Controller::Login::OpenID - allows a User to login via OpenID

=head1 SYNOPSIS

    package MyApp::Controller::NeedsAuth;

    sub something : Path Does('NeedsLogin') {
        # Redirects to /login if not logged in
    }

    # Turn on in config
    MyApp->config('Contoller::Login' => { traits => 'Login::OpenID' });

=head1 DESCRIPTION

Provides the C<login> action with a wrapper to redirect to a page which needs
authentication, from which the user was previously redirected. Goes hand in
hand with L<Catalyst::ActionRole::NeedsLogin> .

=head1 WRAPPED METHODS

=head2 login_GET

Wrap around an openid authentication if the C<'openid.mode'> request parameter
is set. Otherwise, use the default login_GET() method.

=head1 SEE ALSO

=over

=item L<CatalystX::SimpleLogin::Controller::Login>

=item L<CatalystX::SimpleLogin::Form::Login>

=back

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut

1; 
