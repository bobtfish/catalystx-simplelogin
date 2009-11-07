package TestAppOpenID::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => q{});

sub index : Path { }

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

