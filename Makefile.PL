use strict;
use warnings;
use inc::Module::Install 0.91;

name 'CatalystX-SimpleLogin';
all_from 'lib/CatalystX/SimpleLogin.pm';

requires 'Moose';
requires 'Catalyst::Runtime' => '5.80005';
requires 'MooseX::MethodAttributes';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::View::TT';
requires 'CatalystX::InjectComponent';
requires 'Moose::Autobox';
requires 'MooseX::Types::Common';
requires 'MooseX::Types';
requires 'File::ShareDir';
requires 'List::MoreUtils';
requires 'HTML::FormHandler';
requires 'namespace::autoclean';

test_requires 'Test::More';
test_requires 'Catalyst::Action::RenderView';
test_requires 'Catalyst::Plugin::Session';
test_requires 'Catalyst::Plugin::Session::State::Cookie';
test_requires 'Catalyst::Plugin::Session::Store::File';
test_requires 'HTTP::Request::Common';

license 'perl';

if ($Module::Install::AUTHOR) {
    system("pod2text lib/CatalystX/SimpleLogin.pm > README") and die;
}

WriteAll();

