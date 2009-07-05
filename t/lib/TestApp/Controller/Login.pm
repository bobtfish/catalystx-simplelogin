package TestApp::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'CatalystX::SimpleLogin::Controller::Login' }

__PACKAGE__->meta->make_immutable;

