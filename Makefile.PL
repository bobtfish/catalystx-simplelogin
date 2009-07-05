use inc::Module::Install;

name 'CatalystX-SimpleLogin';
all_from 'lib/CatalystX/SimpleLogin.pm';

build_requires 'Catalyst::Runtime';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'Test::More';
build_requires 'ok';

WriteAll();
