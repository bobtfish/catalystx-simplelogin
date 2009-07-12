package CatalystX::SimpleLogin::ControllerRole::Login;
use MooseX::MethodAttributes ();
use Moose::Role -traits => 'MethodAttributes';
use namespace::autoclean;

sub login
    :Action
    :ActionClass('REST')
    :Does('FindViewByIsa')
{
}

1;

