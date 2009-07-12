package CatalystX::SimpleLogin::ControllerRole::Login;
use MooseX::MethodAttributes ();
use Moose::Role -traits => 'MethodAttributes';
use namespace::autoclean;

sub login
    :Chained('/')
    :PathPart('login')
    :Args(0)
    :ActionClass('REST')
    :Does('FindViewByIsa')
    :FindViewByIsa('Catalyst::View::TT')
{
}

1;

