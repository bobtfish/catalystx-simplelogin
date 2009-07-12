package CatalystX::SimpleLogin::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }
with 'CatalystX::SimpleLogin::ControllerRole::Login';

__PACKAGE__->meta->make_immutable;

