# 00-vm-mem-dev.t.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

use lib '../lib';
use Test::More 'no_plan';
use Test::Deep;

BEGIN { use_ok('Tower::VM::Memory'); }

my $mem = Tower::VM::Memory->new;
isa_ok $mem, 'Tower::VM::Memory';
is $mem->{size}, 2**32;

$mem = Tower::VM::Memory->new( size => 2**32, );
is $mem->{size},   2**32;
is $mem->{factor}, 2;
is $mem->get_config_size(), 2**32;
cmp_deeply $mem->get_mem, ();

$mem->write_str( 0, 4, "00000001" );
cmp_deeply [ $mem->read( 0, 4 ) ], [ split //, "00000001" ];
cmp_deeply [ $mem->get_mem ], [ split //, "00000001" ];

$mem->write_str( 0, 4, "ffffffff" );
$mem->write_str( 4, 4, "00000001" );
cmp_deeply [ $mem->read( 0, 4 ) ], [ split //, "ffffffff" ];
cmp_deeply [ $mem->get_mem ], [ split //, "ffffffff00000001" ];

$mem->clear;
cmp_deeply $mem->get_mem, ();
