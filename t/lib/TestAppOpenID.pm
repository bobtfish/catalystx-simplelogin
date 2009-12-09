package TestAppOpenID;
use Moose;
use namespace::autoclean;

use Catalyst qw/
    +CatalystX::SimpleLogin
    Authentication
    Session
    Session::Store::File
    Session::State::Cookie
/;
extends 'Catalyst';

__PACKAGE__->config(
    'Plugin::Authentication' => {
        default => {
            credential => {
                class => 'MockOpenID',
            },
        },
    },
    'Controller::Login' => {
         login_form_class_roles => [ 'CatalystX::SimpleLogin::Form::LoginOpenID']
    },
);

__PACKAGE__->setup;

1;
