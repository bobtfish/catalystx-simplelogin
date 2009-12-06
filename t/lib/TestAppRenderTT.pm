package TestAppRenderTT;;
use Moose;
use namespace::autoclean;

extends 'TestAppBase';

__PACKAGE__->config(
    'Controller::Login' => {
        traits => ['RenderAsTTTemplate', 'Logout'],
    },
);

__PACKAGE__->setup;

__PACKAGE__->meta->make_immutable( replace_constructor => 1 );

