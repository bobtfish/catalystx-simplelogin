package TestAppBase::Script::Server;
use Moose;
use MooseX::Types::Moose qw/Str/;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

extends 'Catalyst::Script::Server';

my $appname = do {
    my $re = q{^TestApp(|DBIC|OpenID|Redirect|RenderTT)$};
    subtype Str,
    where { /$re/ },
    message { "Application name must match /$re/" };
};

# FIXME
# Gross, but overriding NoGetopt with Getopt doesn't work
# right, and nor does +application_name with cmd_aliases
# (as Moose uses a white list of options you can change
# with has +).
__PACKAGE__->meta->remove_attribute('application_name');
has application_name => (
    isa => $appname,
    traits => [qw/Getopt/],
    cmd_aliases   => ['app', 'name'],
    is       => 'ro',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
