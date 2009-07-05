#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/..";
use Catalyst::Test 'TestApp';

print request($ARGV[0])->content . "\n";

1;
