use strict;
use warnings;
use inc::Module::Install 0.91;

name 'CatalystX-SimpleLogin';
all_from 'lib/CatalystX/SimpleLogin.pm';

requires 'Moose';
requires 'Catalyst::Runtime' => '5.80005';
requires 'Moose::Autobox';
requires 'MooseX::Types::Common';
requires 'MosoeX::Types::Moose';
requires 'namespace::autoclean';

test_requires 'Test::WWW::Mechanize::Catalyst';
test_requires 'Test::More';

license 'perl';

WriteAll();
