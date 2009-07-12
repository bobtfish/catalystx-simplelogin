package CatalystX::SimpleLogin::Form::Login;
use HTML::FormHandler::Moose;
use namespace::autoclean;

extends 'HTML::FormHandler';

has_field 'username' => ( type => 'Text' );
has_field 'password' => ( type => 'Password' );

__PACKAGE__->meta->make_immutable;

