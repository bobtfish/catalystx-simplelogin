package TestAppClearSession;
use Moose;
use namespace::autoclean;

extends 'TestAppBase';

__PACKAGE__->config(
    'Controller::Login' => {
        clear_session_on_logout => 1
    },
    'Plugin::Session' => {
        flash_to_stash => 1
    }
);

__PACKAGE__->setup;

1;
