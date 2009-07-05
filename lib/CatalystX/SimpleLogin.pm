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

CatalystX::SimpleLogin -

=cut

1;
