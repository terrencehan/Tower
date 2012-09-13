# lib/Tower/VM/CPU.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

package Tower::VM::CPU;


sub new{
    my $class = shift;
    my $self = {
        res => {
            "%eax"	=> 0x0,
            "%ecx"	=> 0x0,
            "%edx"	=> 0x0,

            "%ebx"	=> 0x0,
            "%esi"	=> 0x0,
            "%edi"	=> 0x0,

            "%esp"	=> 0x0,
            "%ebp"	=> 0x0,
        }, 
        res_num_to_name => {
            0x0	=> "%eax", 
            0x1	=> "%ecx", 
            0x2	=> "%edx", 
            0x3	=> "%ebx", 
            0x4	=> "%esp", 
            0x5	=> "%ebp", 
            0x6	=> "%esi", 
            0x7	=> "%edi", 
            0xf	=> "none", 	
        },
        cc => {
            "ZF" => 0x00, 
            "SF" => 0x00, 
            "OF" => 0x00, 
        }, 
        stat     => 0x00, 
        pc       => 0x00, 
        byte_code=> "",
    };
    return bless $self, $class;
}

sub _get_hex_form{
	my $val = shift;
	my  $str = sprintf "%.8x", $val;
	$str = substr($str, 8) if length($str) > 8;
	return $str; #shortroute
	return $val;
}

sub _print_hash{
    my ($handle, %hash) = @_;
	for (keys %hash){
		print $handle $_."->". _get_hex_form($hash{$_})."\n";
	}
}

sub print_cc{
    my ($self, $handle) = @_;
    $handle = *STDOUT unless $handle;
    _print_hash $handle, %{$self->{cc}};
}

sub print_res{
    my ($self, $handle) = @_;
    $handle = *STDOUT unless $handle;
    _print_hash $handle, %{$self->{res}};
}

sub get_r_with_num{
    my ($self, $num) = @_;
    return $self->{res}->{$self->{res_num_to_name}->{$num}};
}

sub put_r_with_num{
    my ($self, $num, $val) = @_;
    $self->{res}->{$self->{res_num_to_name}->{$num}} = $val;
}

sub get_cc{
    my ($self, $name) = @_;
    return $self->{cc}->{$name};
}

sub set_cc{
    my ($self, $name, $val) = @_;
    $self->{cc}->{$name} = $val;
}


1;
