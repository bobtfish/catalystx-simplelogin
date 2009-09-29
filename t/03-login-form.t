#!/usr/bin env perl

use strict;
use warnings;
use Test::More;

my $form_class = 'CatalystX::SimpleLogin::Form::Login';
use_ok( $form_class ); 

my $form = $form_class->new;
ok( $form, 'form created OK' );

my $rendered = $form->render;
ok( $rendered, 'form renders' );

# mock up ctx/authenticate
{
    package Catalyst;
    use Moose;
    sub authenticate { 1 }
}

my $ctx = Catalyst->new;

my $values = { username => 'Bob', password => 'bobpw' };
my $result = $form->run( ctx => $ctx, params => $values );
ok( $result, 'result created' );
ok( $result->validated, 'result validated' );
$values->{remember} = 0;
is_deeply( $result->value, $values, 'values correct' );

$form = $form_class->new( field_list => [ '+username' => { accessor => 'user_name' },
        '+password' => { accessor => 'pw' } ] );
$result = $form->run( ctx => $ctx, params => $values );
my $custom_values = { user_name => 'Bob', pw => 'bobpw', remember => 0 };
is_deeply( $result->value, $custom_values, 'accessors used for fields' );


done_testing;
