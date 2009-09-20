package TestAppBase;
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
                class => 'Password',
                password_field => 'password',
                password_type => 'clear'
            },
            store => {
                class => 'Minimal',
                users => {
                    bob => {
                        password => "s00p3r",
                    },
                    william => {
                        password => "s3cr3t",
                    },
                },
            },
        },
    },
);

1;
