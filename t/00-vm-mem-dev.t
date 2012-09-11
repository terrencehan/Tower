use strict;
use warnings;

use lib '../lib';
use Test::Base;
use Test::More 'no_plan';
use Test::Deep;

BEGIN { use_ok ('Tower::VM::Memory'); };

my $mem = Tower::VM::Memory->new;
isa_ok $mem, 'Tower::VM::Memory';
is $mem->{size}, 2 ** 32;

$mem = Tower::VM::Memory->new (
    size => 2 ** 32,
);
is $mem->{size}, 2 ** 32;
is $mem->{factor}, 2;
is $mem->get_size(), 2 ** 32;
cmp_deeply $mem->get_mem, [];

run {

    my $block = shift;

    $mem->put_val_in_4bytes($block->pos1, $block->val1);
    cmp_deeply $mem->get_mem, [split //, $block->str1];

    $mem->put_val_in_4bytes($block->pos2, $block->val2);
    cmp_deeply $mem->get_mem, [split //, $block->str2];

    cmp_deeply [$mem->get_area($block->pos3, $block->len3)], [split //, $block->str3];

    is $mem->get_val($block->pos4, $block->len4), $block->val4;

    $mem->clear;
    cmp_deeply $mem->get_mem, [];

}

__DATA__

=== TEST 1:
--- pos1: 0
--- val1: 1
--- str1: 00000001
--- pos2: 4
--- val2: -1
--- str2: 00000001ffffffff
--- pos3: 0
--- len3: 4
--- str3: 00000001
--- pos4: 0
--- len4: 4
--- val4: 1

=== TEST 2:
--- pos1: 0
--- val1: -1
--- str1: ffffffff
--- pos2: 4
--- val2: -1
--- str2: ffffffffffffffff
--- pos3: 0
--- len3: 4
--- str3: ffffffff
--- pos4: 4
--- len4: 4
--- val4: -1

