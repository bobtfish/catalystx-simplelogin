package CatalystX::SimpleLogin::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole'; }

# Deal with different ways to use this controller here. Yes, I apply the roles directly onto this class FIXME.
sub COMPONENT {
    my ($class, $app, $args) = @_;
    my $login_prefix = 'CatalystX::SimpleLogin::ControllerRole::Login';
    my $login =
        exists $args->{login}
        ? $login_prefix . '::' . $args->{login}
        : $login_prefix;
    # FIXME - This blows goats, if you say roles => [qw/Role1 Role2/],
    #         it doesn't play nice with methodattributes.

    Class::MOP::load_class($login);
    $login->meta->apply($class->meta);

    my $logout = 'CatalystX::SimpleLogin::ControllerRole::Logout';
    Class::MOP::load_class($logout);
    $logout->meta->apply($class->meta);

    $class->meta->make_immutable;
    $class->new($app, $args);
}

1;

