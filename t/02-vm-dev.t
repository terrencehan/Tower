# 02-vm-dev.t
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com
use strict;
use warnings;

use lib '../lib';
use Test::More 'no_plan';

BEGIN { use_ok 'Tower::VM' }
my $vm = Tower::VM->new;
isa_ok $vm, 'Tower::VM';
isa_ok $vm->{mem}, 'Tower::VM::Memory';
isa_ok $vm->{cpu}, 'Tower::VM::CPU::SEQ';

my $byte_code = join "", split "\n", do { local $/; <DATA> };

$vm->start($byte_code);

is $vm->{cpu}->{res}->{"%eax"}, 0xabcd, "start";

__DATA__
30f400000100
30f500000100
8000000024
00
0000
0000000d
000000c0
00000b00
0000a000
a05f
2045
30f000000004
a00f
30f200000014
a02f
8000000042
2054
b05f
90
a05f
2045
501500000008
50250000000c
6300
6222
7300000078
506100000000
6060
30f300000004
6031
30f3ffffffff
6032
740000005b
2054
b05f
90
