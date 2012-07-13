package TestApp::Controller::ChainedExample;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

sub base : Chained('/login/required') PathPart('chainedexample') CaptureArgs(0) {} # Chain everything in the controller off of here.

sub index : Chained('base') PathPart('') Args(0) { # /chainedexample
}

sub item : Chained('base') PathPart('') Args(1) { #/chainedexample/$arg1
    my ($self, $c, $arg1) = @_;
    $c->stash->{arg1} = $arg1;
}

sub no_auth_base : Chained('/login/not_required') PathPart('chainedexample') CaptureArgs(0) {} 

sub public : Chained('no_auth_base') Args(0) {} # /chainedexample/public

__PACKAGE__->meta->make_immutable;
