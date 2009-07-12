package CatalystX::SimpleLogin::ControllerRole::Logout;
use MooseX::MethodAttributes ();
use Moose::Role -traits => 'MethodAttributes';
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

