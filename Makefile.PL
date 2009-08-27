use strict;
use warnings;
use inc::Module::Install 0.91;

BEGIN {
    if ($Module::Install::AUTHOR) {
        require Module::Install::AuthorTests;
        require Module::Install::AuthorRequires;
    }
}

name 'CatalystX-SimpleLogin';
all_from 'lib/CatalystX/SimpleLogin.pm';

requires 'Moose';
requires 'Catalyst::Runtime' => '5.80011';
requires 'MooseX::MethodAttributes' => '0.15';
requires 'Catalyst::Action::REST' => '0.74';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Controller::ActionRole' => '0.12';
requires 'Catalyst::ActionRole::FindViewByIsa';
requires 'Catalyst::View::TT';
requires 'CatalystX::InjectComponent';
requires 'CatalystX::Component::Traits' => '0.08';
requires 'Moose::Autobox' => '0.09';
requires 'MooseX::Types::Common';
requires 'MooseX::Types';
requires 'MooseX::RelatedClassRoles' => '0.004';
requires 'File::ShareDir';
requires 'List::MoreUtils';
requires 'HTML::FormHandler' => '0.26001';
requires 'namespace::autoclean';

test_requires 'Test::More';
test_requires 'Catalyst::Action::RenderView';
test_requires 'Catalyst::Plugin::Session';
test_requires 'Catalyst::Plugin::Session::State::Cookie';
test_requires 'Catalyst::Plugin::Session::Store::File';
test_requires 'HTTP::Request::Common';
test_requires 'Catalyst::ActionRole::ACL';

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

