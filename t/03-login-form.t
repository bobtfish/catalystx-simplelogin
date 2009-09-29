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

done_testing;
