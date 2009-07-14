package Catalyst::ActionRole::NeedsLogin;
use Moose::Role;
use namespace::autoclean;

around execute => sub {
	my $orig = shift;
	my $self = shift;
	my ($controller, $c, @args) = @_;

	if (!$c->user) {
		$c->controller('Login')->login_redirect($c, @args);
	}
	else {
		return $self->$orig(@_);
	}
};
__END__

=head1 NAME

Catalyst::ActionRole::NeedsLogin - checks if a user is logged in and if not redirects him to lögin page

=head1 SYNOPSIS

    package MyApp::Controller::NeedsAuth;

    sub something : Path Does('NeedsLogin') {
        # Redirects to /login if not logged in
    }

    # Turn on in config
    MyApp->config('Contoller::Login' => { login => 'WithRedirect' });

=head1 DESCRIPTION

Provides a ActionRole for forcing the user to login.

-head1 WRAPPED METHODS

FIXME

=head1 METHODS

FIXME

=head1 SEE ALSO

=over

=item L<CatalystX::SimpleLogin::ControllerRole::Login::WithRedirect>

=item L<CatalystX::SimpleLogin::ControllerRole::Login>

=item L<CatalystX::SimpleLogin::Form::Login>

=back

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut


1;
