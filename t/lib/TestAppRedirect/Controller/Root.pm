package TestAppRedirect::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'TestAppBase::Controller::Root' }

after index => sub {
    my ($self, $c) = @_;
    $c->res->body("MOO");
};

sub _needslogin {
    my ($self, $ctx) = @_;
    $ctx->res->body('NeedsLogin works!');
    $ctx->res->header('X-Action-Run'
        =>  ($ctx->res->header('X-Action-Run')||'')
            . $ctx->action
    );
}

sub needslogin :Local :Does('NeedsLogin') {shift->_needslogin(shift)}

sub base : Chained('/') PathPart('') CaptureArgs(0) :Does('NeedsLogin') {shift->_needslogin(shift)}
sub needslogin_chained : Chained('base') Args(0) {shift->_needslogin(shift)}

sub base2 : Chained('/') PathPart('') CaptureArgs(0) { $_[1]->res->header('X-Start-Chain-Run', 1) }
sub needslogin_chained_subpart : Chained('base2') Args(0) :Does('NeedsLogin') {shift->_needslogin(shift)}

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

__PACKAGE__->meta->make_immutable;
