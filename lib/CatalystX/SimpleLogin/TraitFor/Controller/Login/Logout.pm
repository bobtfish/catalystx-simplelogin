package CatalystX::SimpleLogin::TraitFor::Controller::Login::Logout;
use MooseX::MethodAttributes::Role;
use MooseX::Types::Moose qw/Str Bool/;
use namespace::autoclean;

sub logout : Chained('/') PathPart('logout') Args(0) {
    my ($self, $c) = @_;
    $c->logout;
    $self->do_clear_session_on_logout($c) if $self->clear_session_on_logout;
    $c->res->redirect($self->redirect_after_logout_uri($c));
}

has clear_session_on_logout => (
    isa => Bool,
    is => 'ro',
    default => 0,
);

sub do_clear_session_on_logout {
    my ($self, $c) = @_;
    $c->delete_session;
}

sub redirect_after_logout_uri {
    my ($self, $c) = @_;
    $c->uri_for($self->_redirect_after_logout_uri);
}
has _redirect_after_logout_uri => (
    isa => Str,
    default => '/',
    init_arg => 'redirect_after_logout_uri',
    is => 'ro',
);

1;

=head1 NAME

CatalystX::SimpleLogin::TraitFor::Controller::Login::Logout

=head1 DESCRIPTION

Simple controller role for logging users out. Provides a
C<logout> action (at /logout by default) which redirects
the user to the homepage by default.

=head1 ACTIONS

=head2 logout : Chained('/') PathPart('logout') Args(0)

Calls C<< $c->logout >>, then redirects to the logout uri
retuned by C<< $self->redirect_after_logout_uri >>.

=head1 METHODS

=head2 redirect_after_logout_uri

Returns the uri to redirect to after logout.

Defaults to C<< $c->uri_for('/'); >> you can override this
by setting the C<<redirect_after_logout_uri>> key in config
to a path to be passed to C<< $c->uri_for >>.

Alternatively, you can write your own redirect_after_logout_uri
in your Login controller if you are extending CatalystX::SimpleLogin
and it will override the method from this role.

=head2 do_clear_session_on_logout

Deletes the session after a logout.

To enable this use the following in your config:
    __PACKAGE__->config('Controller::Login' => { clear_session_on_logout => 1 });

=head1 SEE ALSO

=over

=item L<CatalystX::SimpleLogin::Controller::Login>

=back

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut

