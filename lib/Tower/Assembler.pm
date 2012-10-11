# lib/Tower/Assembler.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

package Tower::Assembler;

our @ISA = qw/Exporter/;

our @EXPORT_OK = qw/get_file/;
our @EXPORT    = qw/rough_handle_src/;

my %res = (
    "%eax" => 0x0,
    "%ecx" => 0x1,
    "%edx" => 0x2,
    "%ebx" => 0x3,
    "%esp" => 0x4,
    "%ebp" => 0x5,
    "%esi" => 0x6,
    "%edi" => 0x7,
);

my @instr =
  qw( rrmovl cmovle cmovl cmove cmovne cmovge cmovg rmmovl mrmovl irmovl addl subl andl xorl jmp jle jl je jne jge jg call ret pushl popl .byte .word .long .pos .align halt nop iaddl leave);

sub get_file {
    my $file = shift;
    open my $in, "<", $file or die "can not open this file: $file";
    my $src = do { local $/; <$in> };
}

sub rough_handle_src {
    my $src = shift;
    $src =~ s/#.*$//gm;
    $src =~ s/^\s*\n//gm;
    print $src;
    print split /\n/, $src;
}

1;
