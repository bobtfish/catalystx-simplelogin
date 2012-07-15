package CatalystX::SimpleLogin::TraitFor::Controller::Login::WithRedirect;
use MooseX::MethodAttributes::Role;
use Moose::Autobox;
use namespace::autoclean;

requires qw/
    redirect_after_login_uri
/;

around 'redirect_after_login_uri' => sub {
    my ($orig, $self, $c, @args) = @_;
    if (!$c->can('session')) {
        $c->log->warn('No $c->session, cannot do ' . __PACKAGE__);
        return $self->$orig($c, @args);
    }
    return $c->session->{redirect_to_after_login}
        ? delete $c->session->{redirect_to_after_login}
        : $self->$orig($c, @args);
};

before login_redirect => sub {
    my ($self, $c, $message) = @_;
    $c->flash->{error_msg} = $message; # FIXME - Flash horrible
    $c->session->{redirect_to_after_login}
        = $c->req->uri->as_string;
};

1;

__END__

=head1 NAME

CatalystX::SimpleLogin::TraitFor::Controller::Login::WithRedirect - redirect
users who login back to the page they originally requested.

=head1 SYNOPSIS

    package MyApp::Controller::NeedsAuth;

    use Moose;
    use namespace::autoclean;

    # One needs to inherit from Catalyst::Controller in order
    # to get the Does('NeedsLogin') functionality.
    BEGIN { extends 'Catalyst::Controller'; }

    sub inbox : Path Does('NeedsLogin') {
        # Redirects to /login if not logged in
        my ($self, $c) = @_;

        $c->stash->{template} = "inbox.tt2";

        return;
    }

    # Turn on in config
    MyApp->config('Contoller::Login' => { traits => 'WithRedirect' });

=head1 DESCRIPTION

Provides the C<login>
action with a wrapper to redirect to a page which needs authentication, from which the
user was previously redirected. Goes hand in hand with L<Catalyst::ActionRole::NeedsLogin>

=head1 WRAPPED METHODS

=head2 redirect_after_login_uri

Make it use and extract C<< $c->session->{redirect_to_after_login} >> 
if it exists.

=head1 METHODS

=head2 $controller->login_redirect($c, $message)

This sets the error message to $message and sets
C<< $c->session->{redirect_to_after_login} >> to the current URL.

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

