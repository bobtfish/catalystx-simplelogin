package CatalystX::SimpleLogin::Controller::Login;
use Moose;
use Moose::Autobox;
use MooseX::Types::Moose qw/ ArrayRef /;
use MooseX::Types::Common::String qw/ NonEmptySimpleStr /;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

has 'username_field' => (
    isa => NonEmptySimpleStr,
    required => 1,
    default => 'username',
);

has 'password_field' => (
    isa => NonEmptySimpleStr,
    required => 1,
    default => 'password',
);

has 'extra_auth_fields' => (
    isa => ArrayRef[NonEmptySimpleStr],
    is => 'ro',
    default => sub { [] },
);

sub _auth_fields {
    my ($self) = @_;

    return @{ $self->extra_auth_fields },
        map { $self->$_() } qw/ username_field password_field /;
}

sub login : Chained('/') PathPart('login') Args(0) ActionClass('REST') {}

sub login_GET {}

sub login_POST {
    my ($self, $c) = @_;

    my $p = $c->req->body_parameters;
    $c->authenticate({
        map { $_ => ($p->{$_}->flatten)[0] } $self->_auth_fields
    });
}

__PACKAGE__->meta->make_immutable;

