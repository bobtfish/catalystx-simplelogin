package TestAppRenderTT;;
use Moose;
use namespace::autoclean;

extends 'TestAppBase';

__PACKAGE__->config(
    'Controller::Login' => {
        # No config needed, you get renderastt by default :)
    },
);

__PACKAGE__->setup;

1;
