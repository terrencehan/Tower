# t/07-vm-mem-helper-dev.t
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

use lib '../lib';
use Test::Base 'no_plan';
use Test::Deep;
use Tower::VM::Memory;

BEGIN { use_ok('Tower::VM::Memory::Helper'); }

use Tower::VM::Memory::Helper qw/
  get_val
  put_val_in_4bytes
  /;

my $mem = Tower::VM::Memory->new;

run {

    my $block = shift;

    put_val_in_4bytes $mem, $block->pos, $block->val;

    is get_val( $mem, $block->pos, 4 ), $block->val;
}

__DATA__

=== TEST 1:
--- pos: 1
--- val: 1

=== TEST 2:
--- pos: 4
--- val: 1

=== TEST 3:
--- pos: 0
--- val: -1

=== TEST 4:
--- pos: 18
--- val: 255

=== TEST 5:
--- pos: 18
--- val: 0

=== TEST 6:
--- pos: 18
--- val: -256
