#line t/08-assembler.t
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

use lib '../lib';
use Test::Base 'no_plan';
use Tower::Assembler;

BEGIN { use_ok('Tower::Assembler'); }

run {
    my $block = shift;
    is translate( $block->src ), $block->byte_code;
};

#============temp
if (0) {
    use Tower::Assembler::Parser;
    use Data::Dump qw/dump/;
    my $src = <<end;
rmmovl %eax, 4(%esp)
end

    my $parser = Tower::Assembler::Parser->new;

    dump $parser->program($src);
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

=== Test6:
--- src
irmovl $-1, %ebx
--- byte_code: 30f3ffffffff

=== Test7:
--- src
irmovl $-4, %ebx
--- byte_code: 30f3fffffffc

=== Test8:
--- src
irmovl STACK, %ebx
--- byte_code: 30f3STACK

=== Test9:
--- src
rmmovl  %eax, -4(%ebx)
--- byte_code: 4003fffffffc

=== Test10:
--- src
rmmovl  %eax, 4(%ebx)
--- byte_code: 400300000004

=== Test11:
--- src
mrmovl -4(%ebx), %eax
--- byte_code: 5003fffffffc

=== Test12:
--- src
pushl %eax
--- byte_code: a00f

=== Test13:
--- src
popl %eax
--- byte_code: b00f

=== Test14:
--- src
call Main
--- byte_code: 80Main
