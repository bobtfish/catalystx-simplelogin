package CatalystX::SimpleLogin::Controller::Login;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole'; }

# Deal with different ways to use this controller here
# FIXME - This is waaay bigger/uglier than it should be..
sub COMPONENT {
    my ($class, $app, $args) = @_;
    my $login_prefix = 'CatalystX::SimpleLogin::ControllerRole::Login';
    my $login =
        exists $args->{login}
        ? $login_prefix . '::' . $args->{login}
        : $login_prefix;
    # FIXME - This blows goats, if you say roles => [qw/Role1 Role2/],
    #         it doesn't play nice with methodattributes.
    my $actual_class = Moose::Meta::Class->create_anon_class(
        superclasses => [ $class->meta->superclasses ],
    )->name();
    Moose::Util::apply_all_roles($actual_class->meta, $login);
    Moose::Util::apply_all_roles($actual_class->meta, 'CatalystX::SimpleLogin::ControllerRole::Logout');
    $actual_class->meta->make_immutable;
    $actual_class->new($c, $args);
}

__PACKAGE__->meta->make_immutable;

