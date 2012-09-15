# lib/Tower/VM.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

use Tower::VM::CPU::SEQ;
use Tower::VM::Memory;

package Tower::VM;


sub new{
    my $class = shift;
    my $self = {
        cpu => Tower::VM::CPU::SEQ->new,
        mem => Tower::VM::Memory->new,
    };
    return bless $self, $class;
}

sub start{
    my ($self, $byte_code) = @_;
    $self->{mem}->write_str(0, (length $byte_code)/2, $byte_code);
    $self->{cpu}->start($self->{mem}, 0x00);
}

1;
