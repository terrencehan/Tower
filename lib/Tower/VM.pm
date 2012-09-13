# lib/Tower/VM.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

use lib '../'; #just for syntax check, should not exist in release version
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

1;
