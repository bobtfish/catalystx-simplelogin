#!/usr/bin/env perl

use strict;
use warnings;
use Test::More 'no_plan';
use HTTP::Request::Common;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Test 'TestAppRedirect';
my ($res, $c);

($res, $c) = ctx_request(GET 'http://localhost/needsloginandhasacl');
TODO: {
    local $TODO = 'Known broken';
is($res->code, 302, 'ACL Role got applied before NeedsLogin role');
}

