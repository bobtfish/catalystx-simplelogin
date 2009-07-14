package TestAppRedirect::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole' }

__PACKAGE__->config(namespace => q{});

sub index : Path { }

sub needslogin :Local :Does('NeedsLogin') {
    my ($self, $c) = @_;
    $c->res->body('NeedsLogin works!');
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

