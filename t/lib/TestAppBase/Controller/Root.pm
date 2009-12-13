package TestAppBase::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole' }

__PACKAGE__->config(
    namespace => '',
);

sub auto : Action {
    my ($self, $c) = @_;
    $c->stash->{additional_template_paths} =
          [$c->config->{home} . '/../TestAppBase/root'];
}

sub index : Path { }

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;
