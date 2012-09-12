# Helper.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

package Tower::VM::Memory::Helper;

use Tower::Tool::Complement qw/to_decimal/;


sub get_val($$){
    #arguments:
    #   $pos
    #   n = $len
    #get the value in decimal form of n bytes at the beginning of pos
    my $self		= shift;
    my ($pos, $len) = @_;
    return to_decimal(join "", $self->get_area($pos, $len));
}

sub put_val_in_4bytes($$){
    #arguments:
    #   $pos $val
    #   put the complement of $val in 4 bytes
    my $self		= shift;
    my $factor		= $self->{factor};
    my ($pos, $val)	= @_;
    my $str	 = sprintf "%.8x", $val;
    $str	 = substr($str, 8) if length($str) > 8;
    @{$self->{buf}}[$pos * $factor .. $pos * $factor + $self->{scalar_len} * $factor -1] = (split //, $str);
}

sub get_mem{
    #return the whole $mem
    my $mem =  shift;
    return $mem->{buf};
}

sub show_mem{
    #TODO need more beautiful format
    $self = shift;
    print @{$self->{buf}};
    print "\n";
}


1;
