package Tower::VM::Memory;

use Tower::Tool::Complement qw/to_decimal/;

sub new{
    $class = shift;
    %mem = (
        size	=> 2 ** 32, 
        buf		=> [], 
        @_,
    );
    return bless \%mem, $class;
}

sub get_size{ return shift->{size}; }

sub clear{ shift->{buf} = []; }

sub get_val{
}

sub get_area{

}

sub put{
    my $self = shift;
    my ($len, $pos, $val) = @_;
    my  $str = sprintf "%.8x", $val;
    $str = substr($str, 8) if length($str) > 8;
    $self->{buf}->[$pos * 2 .. $pos * 2 + $len * 2 -1] = split //, $str;
    #return $self->{buf};
}

1;
