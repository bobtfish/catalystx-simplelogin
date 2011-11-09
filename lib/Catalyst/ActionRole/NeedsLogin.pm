package Catalyst::ActionRole::NeedsLogin;
use Moose::Role;
use namespace::autoclean;

around execute => sub {
	my $orig = shift;
	my $self = shift;
	my ($controller, $c, @args) = @_;

	if (!$c->user) {
		my $message = ($self->attributes->{LoginRedirectMessage}[0])
            ? $self->attributes->{LoginRedirectMessage}[0]
            :'You need to login to view this page!';
		$c->controller('Login')->login_redirect($c, $message, @args);
		$c->detach;
	}
	else {
		return $self->$orig(@_);
	}
};

1;

__END__

=head1 NAME

Catalyst::ActionRole::NeedsLogin - checks if a user is logged in and if not redirects him to login page

=head1 SYNOPSIS

    package MyApp::Controller::NeedsAuth;
    
    use Moose;
    use namespace::autoclean;

    # One needs to inherit from Catalyst::Controller::ActionRole in order
    # to get the Does('NeedsLogin') functionality.
    BEGIN { extends 'Catalyst::Controller::ActionRole'; }

    sub inbox : Path Does('NeedsLogin') {
        # Redirects to /login if not logged in
        my ($self, $c) = @_;

        $c->stash->{template} = "inbox.tt2";

        return;
    }

    sub inbox : Path Does('NeedsLogin') :LoginRedirectMessage('Your custom Message') {
        # Redirects to /login if not logged in-
    }

    # Turn on in config
    MyApp->config('Contoller::Login' => { traits => ['WithRedirect'] });

=head1 DESCRIPTION

Provides a ActionRole for forcing the user to login.

=head1 WRAPPED METHODS

=head2 execute

If there is no logged-in user, call the login_redirect() method in the
C<'Login'> controller with the Catalyst context object, $c, and the
message specified by the C<:LoginRedirectMessage('Message here')> method
attribute (see the synopsis).

If there is a user logged-in (i.e: C<< $c->user >> is true), execute the body
of the action as it is.

=head1 SEE ALSO

=over

=item L<CatalystX::SimpleLogin::TraitFor::Controller::Login::WithRedirect>

=item L<CatalystX::SimpleLogin::Controller::Login>

=item L<CatalystX::SimpleLogin::Form::Login>

=back

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut

