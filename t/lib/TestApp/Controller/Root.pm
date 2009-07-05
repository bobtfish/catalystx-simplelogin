package TestApp::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => q{});

# your actions replace this one
sub main :Path { $_[1]->res->body('<h1>It works</h1>') }

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

