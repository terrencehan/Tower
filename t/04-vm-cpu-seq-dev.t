# 04-vm-cpu-seq-dev.t
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

use lib '../lib';
use Test::More 'no_plan';

use Tower::VM::Memory;
use Tower::VM::CPU::Constant;
use Tower::VM::Memory::Helper qw/ get_val put_val_in_4bytes /;

BEGIN { use_ok 'Tower::VM::CPU::SEQ' }

my $seq = Tower::VM::CPU::SEQ->new;
isa_ok $seq, 'Tower::VM::CPU::SEQ';
isa_ok $seq, 'Tower::VM::CPU';

#for (keys %{$seq}){
#print $_."\n";
#}

$seq->handle_halt;
is $seq->{stat}, $HLT, "handle_halt";

for ( 0 .. 7 ) {
    $seq->{pc}   = $_;
    $seq->{valC} = $_;
    $seq->{rB}   = $_;
    $seq->handle_irmovl;
    no strict;
    is $seq->{res}->{ $seq->{res_num_to_name}->{$_} }, $_, "handle_irmovl";
    is $seq->{pc}, $_ + 6, "handle_irmovl";
}

for ( 0 .. 3 ) {
    ( $seq->{rA}, $seq->{rB} ) = ( $_, 7 - $_ );
    $seq->{valA} = $seq->get_r_with_num( $seq->{rA} );
    $seq->handle_rrmovl;
}
for ( 0 .. 3 ) {
    is $seq->{res}->{ $seq->{res_num_to_name}->{$_} }, $_, "handle_rrmovl";
}
for ( 4 .. 7 ) {
    is $seq->{res}->{ $seq->{res_num_to_name}->{$_} }, 7 - $_, "handle_rrmovl";
}

my $mem = Tower::VM::Memory->new;

#set the value of register as 0 to 7 in order of the SN of Res. Then call handle_rmmovl, write all this number into memory. Check it with Tower::VM::Memory::Helper::get_val
for ( 0 .. 7 ) {
    $seq->{pc}   = $_;
    $seq->{valC} = $_;
    $seq->{rB}   = $_;
    $seq->handle_irmovl;

    $seq->{valB} = 0;
    $seq->{valC} = 4 * $_;
    $seq->{valA} = $_;
    $seq->handle_rmmovl($mem);
    is get_val( $mem, 4 * $_, 4 ), $_, "handle_rmmovl";
}

#set all the value of regitster as 0;
for ( 0 .. 7 ) {
    no strict;
    $seq->{valC} = 0;
    $seq->{rB}   = $_;
    $seq->handle_irmovl;
}

for ( 0 .. 7 ) {
    $seq->{valB} = 0;
    $seq->{valC} = 4 * $_;
    $seq->{rA}   = $_;
    $seq->handle_mrmovl($mem);
    is $seq->get_r_with_num($_), $_, "handle_mrmovel";
}

#now the value of registers is 0 .. 7 in the order or sequence of number

$seq->{ifun} = $FSUBL;
$seq->{valA} = 8;
$seq->{valB} = 1;
$seq->{rB}   = 0;
$seq->handle_opl;
is $seq->get_r_with_num(0), -7, "handle_opl";
is $seq->{cc}->{"ZF"}, 0, "handle_opl";
is $seq->{cc}->{"SF"}, 1, "handle_opl";

put_val_in_4bytes $mem, 1, 0x100;
$seq->{pc}   = 0;
$seq->{ifun} = $FJMP;
$seq->handle_jXX($mem);
is $seq->{pc}, 0x100, "handle_jXX";

$seq->{pc}         = 0;
$seq->{ifun}       = $FJGE;
$seq->{cc}->{'ZF'} = 1;
$seq->{cc}->{'SF'} = 0;
$seq->handle_jXX($mem);
is $seq->{pc}, 0x100, "handle_jXX";

put_val_in_4bytes $mem, 1, 0x55;
$seq->{res}->{"%esp"} = 0x100;
$seq->{pc} = 0x00;
$seq->handle_call($mem);
is $seq->{pc}, 0x55, "handle_call";
is $seq->{res}->{"%esp"}, 0xfc, "handle_call";
is get_val( $mem, 0xfc, 4 ), 0x05, "handle_call";

#handle_ret test is following the handle_call above.
$seq->handle_ret($mem);
is $seq->{pc}, 0x05, "handle_ret";

$seq->{pc}            = 0;
$seq->{res}->{"%esp"} = 0x100;
$seq->{valA}          = 0xabc;
$seq->handle_pushl($mem);
is $seq->{pc}, 2, "handle_pushl";
is get_val( $mem, $seq->{res}->{"%esp"}, 4 ), 0xabc, "handle_pushl";

#handle_pop test is following the handle_pushl above.
$seq->{pc} = 0;
$seq->{rA} = 0;
$seq->handle_popl($mem);
is $seq->{pc}, 2, "handle_popl";
is $seq->get_r_with_num(0), 0xabc, "handle_popl";

$seq = Tower::VM::CPU::SEQ->new;

#$mem->write_str(0, 6, "30f400000110");
$mem->write_str( 0, 7, "30f40000011000" );
$seq->run_next_instruction($mem);
is $seq->{res}->{"%esp"}, 0x110, "run_next_instruction";
$seq->run_next_instruction($mem);
is $seq->{stat}, $HLT, "run_next_instruction";
$seq->{pc} = 0x00;
$seq->run_next_instruction($mem);
is $seq->{res}->{"%esp"}, 0x110, "run_next_instruction";

$seq = Tower::VM::CPU::SEQ->new;
my $byte_code = join "", split "\n", do { local $/; <DATA> };
$mem->write_str( 0, ( length $byte_code ) / 2, $byte_code );
$seq->start( $mem, 0x00 );
is $seq->{stat}, $HLT, "start";
is $seq->{res}->{"%eax"}, 0xabcd, "start";

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
