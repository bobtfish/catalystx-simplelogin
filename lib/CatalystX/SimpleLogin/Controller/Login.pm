package CatalystX::SimpleLogin::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole'; }

with 'CatalystX::SimpleLogin::ControllerRole::Login'; # FIXME - This blows goats, if you say with qw/Role1 Role2/
with 'CatalystX::SimpleLogin::ControllerRole::Logout';#         it doesn't play nice with methodattributes.

#__PACKAGE__->meta->make_immutable;
1;

