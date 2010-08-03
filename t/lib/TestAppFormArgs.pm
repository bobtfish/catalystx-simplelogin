package TestAppFormArgs;
use Moose;
use namespace::autoclean;

extends 'TestAppBase';

__PACKAGE__->config(
    'Controller::Login' => {
        # Doing our own templates, without the redirect stuff.
        traits => ['-WithRedirect', '-RenderAsTTTemplate'],
        login_form_args => {
           field_list => [
               extra_field => { type => 'Text', label => 'Testing Form Args' }, 
               '+submit' => { value => 'Login' },
           ],  
        },
    },
);

__PACKAGE__->setup;

1;

