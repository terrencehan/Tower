# 02-vm-dev.t
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com
use strict;
use warnings;

use lib '../lib';
use Test::More 'no_plan';

BEGIN{use_ok 'Tower::VM'};
my $vm = Tower::VM->new;
isa_ok $vm, 'Tower::VM';
isa_ok $vm->{mem}, 'Tower::VM::Memory';
isa_ok $vm->{cpu}, 'Tower::VM::CPU::SEQ';
