#use strict;
#use warnings;

use lib '../lib';
use Test::More 'no_plan';
use Test::Deep;

BEGIN { use_ok ('Tower::VM::Memory'); };

my $mem = Tower::VM::Memory->new;
isa_ok $mem, Tower::VM::Memory;
is $mem->{size}, 2 ** 32;

my $mem = Tower::VM::Memory->new (
    size => 4,
);
is $mem->{size}, 4;
is $mem->get_size(), 4;
cmp_deeply $mem->{buf}, [];
$mem->put(4, 0, 1);
#cmp_deeply  $mem->{buf}, [split //, "00000001"];
for (@{$mem->{buf}}){
    print $_."\n";
}
