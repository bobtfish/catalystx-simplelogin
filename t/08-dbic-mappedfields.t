use strict;
use warnings;
use Test::More;
use Test::Exception;
use Class::MOP;
use HTTP::Request::Common;
use FindBin qw/$Bin/;
use lib "$Bin/lib";

BEGIN {
    my @needed = qw/
        Catalyst::Model::DBIC::Schema
        Catalyst::Authentication::Store::DBIx::Class
        DBIx::Class::Optional::Dependencies
    /;
    plan skip_all => "One of the required classes for this test $@ (" . join(',', @needed) . ") not found."
        unless eval {
            Class::MOP::load_class($_) for @needed; 1;
        };
    plan skip_all => 'Test needs ' . DBIx::Class::Optional::Dependencies->req_missing_for('admin')
        unless DBIx::Class::Optional::Dependencies->req_ok_for('admin');
}

use Catalyst::Test qw/TestAppDBIC/;

my $db_file = "$Bin/lib/TestAppDBIC/testdbic.db";
unlink $db_file if -e $db_file;

use_ok('TestAppDBIC::Schema');

my $schema;
lives_ok { $schema = TestAppDBIC::Schema->connect("DBI:SQLite:$db_file") }
    'Connect';
ok $schema;
lives_ok { $schema->deploy } 'deploy schema';

$schema->resultset('User')->create({
    user_name => 'bob',
    password => 'bbbb',
});

ok(request('/')->is_success, 'Get /');
ok(request('/login')->is_success, 'Get /login');
is(request('/logout')->code, 302, 'Get 302 from /logout');

{
    my ($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 'aaaa']);
    is($res->code, 200, 'get 200 ok as login page redisplayed when bullshit');

    ($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 'bbbb']);
    is($res->code, 302, 'get 302 redirect');
    my $cookie = $res->header('Set-Cookie');
    ok($cookie, 'Have a cookie');
    is($res->header('Location'), 'http://localhost/', 'Redirect to /');
    ok($c->user, 'Have a user in $c');
}

done_testing;

