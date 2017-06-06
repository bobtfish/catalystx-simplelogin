#!/usr/bin/env perl

use strict;
use warnings;
use Test::More 'no_plan';
use HTTP::Request::Common;
use File::Path;
use Path::Class;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Test 'TestAppFormArgs';
my ($res, $c);

ok(request('/')->is_success, 'Get /');
ok(request('/login')->is_success, 'Get /login');
($res, $c) = ctx_request(GET 'http://localhost/login' );
like( $c->res->body, qr/Testing Form Args/, 'extra form field added' );
like( $c->res->body, qr/\<input type="submit" name="submit" id="submit" value="Login" (tabindex="4" )?\/\>/, 'submit button modified' );

rmtree( dir( TestAppFormArgs->_session_file_storage->{_Backend}{_Root} )->parent->parent , { } );

