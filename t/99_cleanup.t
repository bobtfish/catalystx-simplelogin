use strict;
use warnings;
use Test::More; 
use Catalyst::Utils;
use HTTP::Request::Common;
use File::Path;

# setup library path
use FindBin qw($Bin);
use lib "$Bin/lib";

use Catalyst::Test 'TestAppRedirect';

my ($res, $c) = ctx_request(POST 'http://localhost/login', [username => 'bob', password => 'aaaa']);
is($res->code, 200, 'get errors in login form');

rmtree( TestAppRedirect->_session_file_storage->{_Backend}{_Root} );

done_testing();

