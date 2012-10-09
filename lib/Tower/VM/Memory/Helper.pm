# VM/Memory/Helper.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

package Tower::VM::Memory::Helper;

use Tower::Tool::Complement qw/to_decimal/;

@ISA = qw/Exporter/;

@EXPORT_OK = qw/get_val put_val_in_4bytes/;

sub get_val {

    #arguments:
    #   $mem memory object
    #   $pos address of first byte
    #   n = $len
    #get the value in decimal form of n bytes at the beginning of pos
    my ( $mem, $pos, $len ) = @_;
    return to_decimal( join "", $mem->read( $pos, $len ) );
}

sub _put_val {

    #internal fuction
    my ( $mem, $pos, $val, $bytes ) = @_;
    my $len    = $bytes * 2;
    my $factor = $mem->{factor};
    my $str    = sprintf "%.${t}x", $val;
    $str = substr( $str, $len ) if length($str) > $len;
    @{ $mem->{buf} }[ $pos * $factor .. $pos * $factor + $len - 1 ] =
      ( split //, $str );    #here, $len stand for the lenght in array
}

sub put_val_in_4bytes {

    #arguments:
    #   $mem memory object
    #   $pos $val
    #   put the complement of $val in 4 bytes
    my ( $mem, $pos, $val ) = @_;
    _put_val( $mem, $pos, $val, 4 );
}

sub put_val_in_2bytes {

    # umimplement
}

sub show_mem {

    #TODO need more beautiful format
    $self = shift;
    print @{ $self->{buf} };
    print "\n";
}

1;
