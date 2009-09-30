package CatalystX::SimpleLogin::TraitFor::Controller::Login::Logout;
use MooseX::MethodAttributes::Role;
use namespace::autoclean;

sub logout : Chained('/') PathPart('logout') Args(0) {
    my ($self, $c) = @_;
    $c->logout;
    $c->res->redirect($self->redirect_after_logout_uri($c));
}

sub redirect_after_logout_uri {
    my ($self, $c) = @_;
    $c->uri_for('/');
}

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

Defaults to C<< $c->uri_for('/'); >>

=head1 TODO

=over

=item Make logout uri come from config

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

