package TestAppDBIC::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'TestAppBase::Controller::Root' }

__PACKAGE__->meta->make_immutable;
