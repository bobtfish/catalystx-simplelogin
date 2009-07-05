#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 2;
use_ok 'CatalystX::SimpleLogin' or BAIL_OUT;
use_ok 'CatalystX::SimpleLogin::Controller::Login' or BAIL_OUT;

