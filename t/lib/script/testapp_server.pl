#!/usr/bin/env perl
use strict;
use warnings;

use FindBin qw/$Bin/;
use lib "$Bin/../../../lib", "$Bin/../";

use TestAppBase::Script::Server;
TestAppBase::Script::Server->new_with_options->run;

1;
