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

1;

