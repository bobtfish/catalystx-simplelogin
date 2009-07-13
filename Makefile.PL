use strict;
use warnings;
use inc::Module::Install 0.91;

name 'CatalystX-SimpleLogin';
all_from 'lib/CatalystX/SimpleLogin.pm';

requires 'Moose';
requires 'Catalyst::Runtime' => '5.80005';
requires 'MooseX::MethodAttributes';
requires 'Catalyst::Action::REST' => '0.74'; # By which I mean you need db8bb64
                                             # from git://github.com/bobtfish/catalyst-action-rest.git
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Controller::ActionRole';
requires 'Catalyst::ActionRole::FindViewByIsa';
requires 'Catalyst::View::TT';
requires 'CatalystX::InjectComponent';
requires 'Moose::Autobox' => '0.09';
requires 'MooseX::Types::Common';
requires 'MooseX::Types';
requires 'File::ShareDir';
requires 'List::MoreUtils';
requires 'HTML::FormHandler' => '0.27'; # By which I mean you need 9c101960
                                        # from git@github.com:gshank/html-formhandler.git..
requires 'namespace::autoclean';

test_requires 'Test::More';
test_requires 'Catalyst::Action::RenderView';
test_requires 'Catalyst::Plugin::Session';
test_requires 'Catalyst::Plugin::Session::State::Cookie';
test_requires 'Catalyst::Plugin::Session::Store::File';
test_requires 'HTTP::Request::Common';

license 'perl';

resources repository => 'http://github.com/bobtfish/catalystx-simplelogin';

if ($Module::Install::AUTHOR) {
    system("pod2text lib/CatalystX/SimpleLogin.pm > README") and die;
}

WriteAll();

