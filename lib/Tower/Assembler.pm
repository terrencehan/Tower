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

rrmovl: $/.code = { $::address+=2; '20' . Tower::Assembler::emit_res($<__DIRECTIVE1__>)}

irmovl: $/.code = { $::address+=6; Tower::Assembler::emit_irmovl($/)}

rmmovl: $/.code = { $::address+=6; Tower::Assembler::emit_rmmovl($/)}

nil: $/.code = {''}
AttrEND
    $attr->apply( $ptree, 'code' );
}

my $address = 0;

sub emit_res {
    my @res_arr = @{ +shift };
    join '', map { $res{ $_->{__VALUE__} } } @res_arr;
}

sub emit_irmovl {
    my $obj = shift;
    my $str;
    if($obj->{identifier}){
        $str = $obj->{identifier}->{__VALUE__};
    }
    else{
        $str = sprintf "%.8x", $obj->{immediate}->{number}->{__VALUE__};
    }
    "30f" . $res{$obj->{reg}->{__VALUE__}} . $str;
}

sub handle_address {

}

1;
