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
        ? $c->session->{redirect_to_after_login}
        : $self->$orig($c, @args);
};

sub login_redirect {
    my ($self, $c, $message) = @_;
    $c->flash->{error_msg} = $message; # FIXME - Flash horrible
    $c->session->{redirect_to_after_login} = $c->uri_for($c->action, $c->req->captures, $c->req->args->flatten, $c->req->parameters);
    $c->response->redirect($c->uri_for($self->action_for("login")));
    $c->detach;
}

1;

__END__

=head1 NAME

CatalystX::SimpleLogin::TraitFor::Controller::Login::WithRedirect - redirect
users who login back to the page they originally requested.

=head1 SYNOPSIS

    package MyApp::Controller::NeedsAuth;

    sub something : Path Does('NeedsLogin') {
        # Redirects to /login if not logged in
    }

    # Turn on in config
    MyApp->config('Contoller::Login' => { traits => 'Login::WithRedirect' });

=head1 DESCRIPTION

Provides the C<login>
action with a wrapper to redirect to a page which needs authentication, from which the
user was previously redirected. Goes hand in hand with L<Catalyst::ActionRole::NeedsLogin>

=head1 WRAPPED METHODS

=head2 redirect_after_login_uri

FIXME

=head1 METHODS

=head2 login_redirect

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

