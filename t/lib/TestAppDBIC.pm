package TestAppDBIC;
use Moose;
use namespace::autoclean;

extends 'TestAppBase';
__PACKAGE__->setup_home;
__PACKAGE__->config(
    'Controller::Login' => {
        login_form_args => {
            authenticate_username_field_name => 'user_name',
        },
    },
    'Model::DB' => {
        connect_info => {
            dsn => 'dbi:SQLite:' . __PACKAGE__->path_to('testdbic.db'),
            user => '',
            password => '',
        },
    },
    'Plugin::Authentication' => {
        default => {
            credential => {
                class => 'Password',
                password_field => 'password',
                password_type => 'clear'
            },
            store => {
                class => 'DBIx::Class',
                user_model => 'DB::User',
            },
        },
    },
);

__PACKAGE__->setup;

1;
