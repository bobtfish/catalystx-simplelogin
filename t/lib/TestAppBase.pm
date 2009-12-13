package TestAppBase;
use Moose;
use CatalystX::InjectComponent;
use namespace::autoclean;

use Catalyst qw/
    +CatalystX::SimpleLogin
    Authentication
    Session
    Session::Store::File
    Session::State::Cookie
/;
extends 'Catalyst';
# HULK SMASH.
# Catalyst->import calls setup_home, which results in config for
# the root directory being set if not already set. Ergo we end
# up with the templates for this class, rather than the subclass,
# which is fail..
# FIXME - Do the appropriate handwave here to tell TT about the extra
#         base app include path, rather than throwing the root dir
#         away..
__PACKAGE__->config(home => undef, root => undef);
# Normal default config.
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

after 'setup_components' => sub {
    my ($app) = @_;
    CatalystX::InjectComponent->inject(
        into => $app,
        component => 'TestAppBase::Controller::Root',
        as => 'Root',
    ) unless $app->controller('Root');
    CatalystX::InjectComponent->inject(
        into => $app,
        component => 'TestAppBase::View::HTML',
        as => 'HTML',
    ) unless $app->controller('HTML');
};

1;
