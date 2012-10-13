# lib/Tower/Assembler.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

package Tower::Assembler;

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

sub translate {
    my $as_code = shift;
    my $parser  = Tower::Assembler::Parser->new;
    my $ptree   = $parser->program($as_code);
    emit_byte_code($ptree);

    #$ptree;
}

sub emit_byte_code {
    my $ptree = shift;
    my $attr  = new Language::AttributeGrammar << 'AttrEND';
program: $/.code = { $<statement_list>.code }

statement_list: $/.code = { $<statement_list>.code . $<statement>.code}

statement: $/.code = {$<child>.code}

halt: $/.code = { $::address++;'00' }

nop: $/.code = { $::address++;'01' }

ret: $/.code = { $::address++;'90' }

rrmovl: $/.code = { $::address+=2; '20' . $<rA>.code . $<rB>.code}

irmovl: $/.code = { $::address+=6; Tower::Assembler::emit_irmovl($/)}

rmmovl: $/.code = { $::address+=6; '40' . $<rA>.code . $<rB>.code . $<number>.code}

mrmovl: $/.code = { $::address+=6; '50' . $<rA>.code . $<rB>.code . $<number>.code}

#jxx: $/.code = { $::address+=5;  }

pushl: $/.code = { $::address+=2; 'a0'. $<rA>.code . 'f'}

popl: $/.code = { $::address+=2; 'b0'. $<rA>.code . 'f'}

call: $/.code = { $::address+=5; '80' . $<identifier>.code }

identifier: $/.code = { $<__VALUE__> }

rA: $/.code = { $<reg>.code }

rB: $/.code = { $<reg>.code }

reg: $/.code = { Tower::Assembler::emit_reg $<__VALUE__> }

number: $/.code = { Tower::Assembler::emit_num $<__VALUE__> }

nil: $/.code = {''}
AttrEND
    $attr->apply( $ptree, 'code' );
}

my $address = 0;

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

sub handle_address {

}

1;
