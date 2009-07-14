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

__END__

=head1 NAME

CatalystX::SimpleLogin::Controller::Login - Configurable login controller

=head1 SYNOPSIS

    # For simple useage exmple, see CatalystX::SimpleLogin, this is a
    # full config example
    __PACKAGE__->config(
        'Controller::Login' => {
            login => 'WithRedirect', # Optional, enables redirect-back feature
            actions => {
                login => { # Also optional
                    PathPart => ['theloginpage'], # Change login action to /theloginpage
                },
                logout => {},
            },
        },
    );

=head1 DESCRIPTION

=head1 SEE ALSO

=over

=item L<CatalystX::SimpleLogin::ControllerRole::Login>

=item L<CatalystX::SimpleLogin::ControllerRole::Login::WithRedirect>

=item L<CatalystX::SimpleLogin::ControllerRole::Logout>

=back

=head1 AUTHORS

See L<CatalystX::SimpleLogin> for authors.

=head1 LICENSE

See L<CatalystX::SimpleLogin> for license.

=cut

