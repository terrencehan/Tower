#line t/07-assembler.t
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

use lib '../lib';
use Test::Base 'no_plan';
use Tower::Assembler ;

BEGIN { use_ok('Tower::Assembler'); }

run {
    my $block = shift;
    is translate($block->src), $block->byte_code;
}

__DATA__
=== Test1:
--- src
halt
--- byte_code: 00

=== Test2:
--- src
nop
--- byte_code: 01

=== Test3:
--- src
ret
--- byte_code: 90 

=== Test4:
--- src
rrmovl %eax, %ebx
--- byte_code: 2003

=== Test5:
--- src
irmovl $4, %ebx
--- byte_code: 30f300000004

