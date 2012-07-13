package TestAppFormArgs::Controller::NeedsAuth;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub foo : Chained('/') PathPart('needsauth') Args(0) Does('NeedsLogin') {
    my ($self, $c) = @_;
    $c->res->body("SEKRIT");
}

__PACKAGE__->meta->make_immutable;

