# lib/Tower/Assembler.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

package Tower::Assembler;

use 5.010;
use strict;
use warnings;

use Tower::Assembler::AST;
use Tower::Assembler::Parser;
use Language::AttributeGrammar;
use Data::Dump qw/dump/;

our @ISA = qw/Exporter/;

our @EXPORT_OK = qw//;
our @EXPORT    = qw/translate/;

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

our $address = 0;
our %label;    #label=>address

sub translate {
    my $as_code = shift;
    $address = 0;
    my $parser     = Tower::Assembler::Parser->new;
    my $ptree      = $parser->program($as_code) or die 'syntax error';
    my $result_str = emit_byte_code($ptree);
    for ( keys %label ) {
        my $hex_form = sprintf "%.8x", $label{$_};
        $result_str =~ s/$_/$hex_form/g;
    }
    $result_str;

    #$ptree;
}

sub emit_byte_code {
    my $ptree = shift;
    my $attr  = new Language::AttributeGrammar << 'AttrEND';
program: $/.code = { $<statement_list>.code }

statement_list: $/.code = { $<statement_list>.code . $<statement>.code}

statement: $/.code = {$<child>.code}

halt: $/.code = { Tower::Assembler::handle_address(1);'00' }

nop: $/.code = { Tower::Assembler::handle_address(1);'01' }

ret: $/.code = { Tower::Assembler::handle_address(1);'90' }

rrmovl: $/.code = { Tower::Assembler::handle_address(2); '20' . $<rA>.code . $<rB>.code}

irmovl: $/.code = { Tower::Assembler::handle_address(6); Tower::Assembler::emit_irmovl($/)}

rmmovl: $/.code = { Tower::Assembler::handle_address(6); '40' . $<rA>.code . $<rB>.code . $<number>.code}

mrmovl: $/.code = { Tower::Assembler::handle_address(6); '50' . $<rA>.code . $<rB>.code . $<number>.code}

jxx: $/.code = { Tower::Assembler::handle_address(5); $<jop>.code . $<identifier>.code }

jop: $/.code = { Tower::Assembler::emit_jop $<__VALUE__> }

pushl: $/.code = { Tower::Assembler::handle_address(2); 'a0'. $<rA>.code . 'f'}

popl: $/.code = { Tower::Assembler::handle_address(2); 'b0'. $<rA>.code . 'f'}

call: $/.code = { Tower::Assembler::handle_address(5); '80' . $<identifier>.code }

command: $/.code = { Tower::Assembler::emit_command($/) }

label: $/.code = {Tower::Assembler::handle_label($<identifier>.code); '' }

identifier: $/.code = { $<__VALUE__> }

rA: $/.code = { $<reg>.code }

rB: $/.code = { $<reg>.code }

opl: $/.code = { Tower::Assembler::handle_address(2); $<op>.code . $<rA>.code . $<rB>.code }

op: $/.code = { Tower::Assembler::emit_op($<__VALUE__>) }

reg: $/.code = { Tower::Assembler::emit_reg $<__VALUE__> }

number: $/.code = { Tower::Assembler::emit_num $<__VALUE__> }

comment: $/.code = {''}

nil: $/.code = {''}

eight_zero: $/.code = {'00000000'}
AttrEND
    $attr->apply( $ptree, 'code' );
}

sub emit_reg { $res{ +shift }; }

sub emit_irmovl {
    my $obj = shift;
    my $str;
    if ( $obj->{identifier} ) {
        $str = $obj->{identifier}->{__VALUE__};
    }
    else {
        $str = emit_num( $obj->{immediate}->{number}->{__VALUE__} );
    }
    "30f" . $res{ $obj->{reg}->{__VALUE__} } . $str;
}

sub emit_num {

    # -1 => ffffffff
    #  1 => 00000001
    my $str = sprintf "%.8x", shift;
    $str = substr( $str, 8 ) if length $str > 8;
    $str;
}

sub emit_op {
    my %operations = (
        "addl" => 60,
        "subl" => 61,
        "andl" => 62,
        "xorl" => 63,
    );
    $operations{ +shift };
}

sub emit_jop {
    my %operations = (
        "jmp" => 70,
        "jle" => 71,
        "jl"  => 72,
        "je"  => 73,
        "jne" => 74,
        "jge" => 75,
        "jg"  => 76,
    );
    $operations{ +shift };
}

sub handle_address {
    $address += shift;
}

sub emit_command {
    my $obj = shift;
    if ( $obj->{__PATTERN1__} ) {    #pos|byte|word|long
        given ( $obj->{__PATTERN1__} ) {
            my $hex = hex $obj->{hex}->{__PATTERN1__};
            when ('pos') {
                $address = $hex;
                return '';
            }
            $hex = sprintf "%.8x", $hex;
            when ('byte') {
                handle_address(1);
                $hex = substr( $hex, ( length $hex ) - 2 ) if length $hex > 2;
                return $hex;
            }
            when ('word') {
                handle_address(2);
                $hex = substr( $hex, ( length $hex ) - 4 ) if length $hex > 4;
                return $hex;
            }
            when ('long') {
                handle_address(4);
                $hex = substr( $hex, 8 ) if length $hex > 8;
                return $hex;
            }
        }
    }
    else {    #align
        my $num         = $obj->{number}->{__VALUE__};
        my $old_address = $address;
        $address = $address - $address % $num + $num;
        return "0" x ( 2 * ( $address - $old_address ) );
    }
}

sub handle_label {
    my $label_str = shift;
    $label{$label_str} or $label{$label_str} = $address;
}

1;
