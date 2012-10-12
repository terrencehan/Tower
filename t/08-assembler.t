#line t/07-assembler.t
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

use lib '../lib';
use Test::Base 'no_plan';
use Test::Deep;
use Tower::Assembler qw/get_file/;

BEGIN { use_ok('Tower::Assembler'); }

