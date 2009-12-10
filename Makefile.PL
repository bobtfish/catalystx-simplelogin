use strict;
use warnings;
use inc::Module::Install 0.91;

use Module::Install::AuthorTests;
use Module::Install::AuthorRequires;

name 'CatalystX-SimpleLogin';
all_from 'lib/CatalystX/SimpleLogin.pm';

requires 'Moose';
requires 'Catalyst::Runtime' => '5.80013';
requires 'MooseX::MethodAttributes' => '0.18';
requires 'Catalyst::Action::REST' => '0.74';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::View::TT';
requires 'CatalystX::InjectComponent';
requires 'CatalystX::Component::Traits' => '0.13';
requires 'Moose::Autobox' => '0.09';
requires 'MooseX::Types::Common';
requires 'MooseX::Types';
requires 'MooseX::RelatedClassRoles' => '0.004';
requires 'Moose::Autobox';
requires 'HTML::FormHandler' => '0.28001';
requires 'namespace::autoclean';
requires 'Catalyst::Plugin::Session' => '0.27'; # Required as we use the 'Plugin::Session' config key in ::Manual

test_requires 'Test::More' => '0.94';
test_requires 'Catalyst::Action::RenderView';
test_requires 'Catalyst::Plugin::Session::State::Cookie';
test_requires 'Catalyst::Plugin::Session::Store::File';
test_requires 'HTTP::Request::Common';
test_requires 'Catalyst::Controller::ActionRole' => '0.12';
test_requires 'Catalyst::ActionRole::ACL';

author_requires 'Catalyst::Authentication::Credential::OpenID';
author_requires 'Test::EOL' => '0.3';
author_requires 'Test::NoTabs';
author_requires 'Test::Pod' => '1.14';
author_requires 'Test::Pod::Coverage' => '1.08';

license 'perl';

resources repository => 'http://github.com/bobtfish/catalystx-simplelogin';

tests 't/*.t';
author_tests 't/author';

if ($Module::Install::AUTHOR) {
    system("pod2text lib/CatalystX/SimpleLogin.pm > README") and die;
}

auto_install;
auto_provides;
WriteAll();

