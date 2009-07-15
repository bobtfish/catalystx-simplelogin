#!/usr/bin/env perl

use Test::More;
eval {require Test::EOL };

if ($@) {
    plan skip_all => 'Need Test::EOL installed for line ending tests';
    exit 0;
}

all_perl_files_ok();

