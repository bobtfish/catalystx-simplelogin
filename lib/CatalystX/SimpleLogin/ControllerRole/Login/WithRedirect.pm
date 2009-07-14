package CatalystX::SimpleLogin::ControllerRole::Login::WithRedirect;
use MooseX::MethodAttributes ();
use Moose::Role -traits => 'MethodAttributes';
use namespace::autoclean;

with 'CatalystX::SimpleLogin::ControllerRole::Login';

around 'redirect_after_login_uri' => sub {
    my ($orig, $self, $c, @args) = @_;
    if (!$c->can('session')) {
        $c->log->warn('No $c->session, cannot do ' . __PACKAGE__);
        return $self->$orig($c, @args);
    }
    return $c->session->{redirect_to_after_login}
        ? $c->uri_for('/'.$c->session->{redirect_to_after_login})
        : $self->$orig($c, @args);
};

sub login_redirect {
    my ($self, $c) = @_;
    $c->flash->{error_msg} = 'You need to login to view this page!'; # FIXME - Flash horrible
    $c->session->{redirect_to_after_login} =  $c->request->path;
    $c->response->redirect($c->uri_for($c->controller("Login")->action_for("login")));
}

=head1 NAME
 
CatalystX::SimpleLogin::ControllerRole::Login::WithRedirect - Provides the C<login>
action with a wrapper to redirect to a page which needs authentication, from which the
user was previously redirected. Goes hand in hand with L<Catalyst::ActionRole::NeedsLogin>

=head1 SYNOPSIS
 
package MyApp;
use Moose;
use namespace::autoclean;
 
use Catalyst qw/
+CatalystX::SimpleLogin
Authentication
Session
Session::State::Cookie
Session::Store::File
/;
extends 'Catalyst';
 
__PACKAGE__->config(
'Plugin::Authentication' => { # Auth config here },
'Controller::Login'      => { login => 'WithRedirect', }, #Forces the use of CatalystX::SimpleLogin::ControllerRole::Login::WithRedirect instead of CatalystX::SimpleLogin::ControllerRole::Login
);
 
__PACKAGE__->setup;
 
=head1 AUTHOR
 
Stephan Jauernick (stephan48) C<< <stephan@stejau.de> >>
 
=head1 CONTRIBUTORS
 
=over
 
=item Zbigniew Lukasiak
 
=item Tomas Doran
 
=back
 
=head1 LICENSE
 
Copyright 2009 Stephan Jauernick. Some rights reserved.
 
This sofware is free software, and is licensed under the same terms as perl itself.
 
=cut
1;

