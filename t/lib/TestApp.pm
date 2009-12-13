package TestApp;
use Moose;
use namespace::autoclean;

extends 'TestAppBase';

__PACKAGE__->config(
    'Controller::Login' => {
        # Doing our own templates, without the redirect stuff.
        traits => ['-WithRedirect', '-RenderAsTTTemplate'],
    },
);

__PACKAGE__->setup;

1;

