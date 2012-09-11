package Tower::VM::Memory;

use Tower::Tool::Complement qw/to_decimal/;

sub new{
    $class = shift;
    %mem = (
        factor		=> 2,		#don't alert this
        size		=> 2 ** 32, 
        scalar_len	=> 4, 		#the lenght of a word 
        buf			=> [], 
        @_,
    );
    return bless \%mem, $class;
}

sub get_size{ return shift->{size}; }

sub clear{ shift->{buf} = []; }


sub get_area($$){
    #given a start position and a length, return a segment of  mem array;
    my $self		= shift;
    my $factor 		= $self->{factor};
    my ($pos, $len) = @_;
    return @{$self->{buf}}[$pos * $factor .. $pos * $factor + $len * $factor - 1];
}

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
    my $self =  shift;
    return $self->{buf};
}

sub show{
    #print @mem within a line
    $self = shift;
    print @{$self->{buf}};
    print "\n";
}


1;
