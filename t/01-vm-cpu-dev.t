# 01-vm-cpu-dev.t
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

use lib '../lib';
use Test::Base 'no_plan';

BEGIN { use_ok('Tower::VM::CPU') }

our $cpu = Tower::VM::CPU->new;
isa_ok $cpu, 'Tower::VM::CPU';

run {
    my $block = shift;

    $cpu->put_r_with_num( $block->num1, $block->val1 );
    $cpu->put_r_with_num( $block->num2, $block->val2 );

    is $cpu->get_r_with_num( $block->num1 ), $block->val1;
    is $cpu->get_r_with_num( $block->num2 ), $block->val2;

    my $str;
    open my $handle, ">", \$str;
    $cpu->print_res($handle);
    is $str, $block->res;
    close $handle;

    $cpu->set_cc( $block->cc_name, $block->cc_val );
}

__DATA__
=== Test1:
--- num1: 2
--- val1: 9
--- num2: 0
--- val2: -1
--- res
%eax->ffffffff
%ebp->00000000
%ebx->00000000
%ecx->00000000
%edi->00000000
%edx->00000009
%esi->00000000
%esp->00000000
--- cc_name: SF
--- cc_val: 1

=== Test2:
--- num1: 1
--- val1: 9
--- num2: 7
--- val2: 16
--- res
%eax->ffffffff
%ebp->00000000
%ebx->00000000
%ecx->00000009
%edi->00000010
%edx->00000009
%esi->00000000
%esp->00000000
--- cc_name: ZF
--- cc_val: 123

=== Test3:
--- num1: 3
--- val1: 15
--- num2: 4
--- val2: 6
--- res
%eax->ffffffff
%ebp->00000000
%ebx->0000000f
%ecx->00000009
%edi->00000010
%edx->00000009
%esi->00000000
%esp->00000006
--- cc_name: OF
--- cc_val: 23

=== Test4:
--- num1: 6
--- val1: 15
--- num2: 5
--- val2: 6
--- res
%eax->ffffffff
%ebp->00000006
%ebx->0000000f
%ecx->00000009
%edi->00000010
%edx->00000009
%esi->0000000f
%esp->00000006
--- cc_name: OF
--- cc_val: 123
