package TestAppOpenID;
use Moose;
use namespace::autoclean;

extends 'TestAppBase';

__PACKAGE__->config(
    'Plugin::Authentication' => {
        default => {
            credential => {
                class => 'MockOpenID',
            },
            store => {
                class => 'Null',
            }
        },
    },
    'Controller::Login' => {
         login_form_class_roles => [ 'CatalystX::SimpleLogin::Form::LoginOpenID']
    },
);

__PACKAGE__->setup;

1;
