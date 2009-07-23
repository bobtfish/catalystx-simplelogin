package TestAppRedirect::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole' }

__PACKAGE__->config(namespace => q{});

sub index : Path { }

sub needslogin :Local :Does('NeedsLogin') {
    my ($self, $c) = @_;
    $c->res->body('NeedsLogin works!');
}

sub needslogincustommsg :Local :Does('NeedsLogin') :LoginRedirectMessage('Please Login to view this Test Action')  {
    my ($self, $c) = @_;
    $c->res->body('NeedsLogin works!');
}

sub needsloginandhasacl :Local :Does('NeedsLogin') :Does('ACL') :RequiresRole('abc') :ACLDetachTo('denied') {
    my ($self, $c) = @_;
    $c->res->body('NeedsLogin with ACL works!');
}

sub denied :Private {
     my ($self, $c) = @_;

     $c->res->status('403');
     $c->res->body('Denied!');
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

