# Memory.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

package Tower::VM::Memory;

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

sub get_config_size{ return shift->{size}; }

sub clear{ shift->{buf} = []; }

sub write_arr($$@){
    #arguments:
    # $postion $len(bytes) $data
    my $self = shift;
    my ($pos, $len, @data) = @_;
    my $factor = $self->{factor};
    @{$self->{buf}}[$pos * $factor .. $pos * $factor + $len * $factor -1] = @data;
}

sub write_str($$$){
    #arguments:
    # $postion $len(bytes) $data_str
    my $self = shift;
    my ($pos, $len, $data_str) = @_;
    $self->write_arr($pos, $len, (split //, $data_str));
}

sub read($$){
    #arguments:
    # $postion $len(bytes) 
    my $self        = shift;
    my ($pos, $len) = @_;
    my $factor 		= $self->{factor};
    return @{$self->{buf}}[$pos * $factor .. $pos * $factor + $len * $factor - 1];
}

sub get_mem{
    #return the whole $mem in an array
    my $self =  shift;
    return @{$self->{buf}};
}

1;
