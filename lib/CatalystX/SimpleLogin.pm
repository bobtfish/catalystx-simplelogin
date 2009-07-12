package CatalystX::SimpleLogin;
use Moose::Role;
use CatalystX::InjectComponent;
use namespace::autoclean;

after 'setup_components' => sub {
    my $class = shift;
    CatalystX::InjectComponent->inject(
        into => $class,
        component => 'CatalystX::SimpleLogin::Controller::Login',
        as => 'Controller::Login'
    );
};

=head1 NAME

CatalystX::SimpleLogin - Provide a simple Login controller which can be reused

=head1 SYNOPSIS

    package MyApp;
    use Moose;
    use namespace::autoclean;

    use Catalyst qw/
        +CatlystX::SimpleLogin
        Authentication
        Session
        Session::State::Cookie
        Session::Store::File
    /;
    extends 'Catalyst';

    __PACKAGE__->config(
        'Plugin::Authentication' => { # Auth config here }
    );

    __PACKAGE__->setup;

=head1 DESCRIPTION

CatalystX::SimpleLogin is an application class role which will inject a controller
which is an instance of L<CatalystX::SimpleLogin::Controller::Login> into your
application. This provides a simple login and logout page with only one line of code.

=head1 REQUIREMENTS

=over

=item Working authentication configuration

=item Working session configuration

=item A TT view

=back

=head1 AUTHOR

Tomas Doran (t0m) C<< <bobtfish@bobtfish.net> >>

=head1 LICENSE

Copyright 2009 Tomas Doran. Some rights reserved.

This sofware is licensed under the same terms as perl itself.

=cut

1;

