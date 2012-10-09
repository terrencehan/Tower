# lib/Tower/VM/CPU/Constant.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

package Tower::VM::CPU::Constant;

require Exporter;

our @ISA = qw/Exporter/;
our @EXPORT =
  qw/ $IHALT $INOP $IRRMOVL $IIRMOVL $IRMMOVL $IMRMOVL $IOPL $IJXX $ICALL $IRET $IPUSHL $IPOPL $FADDL $FSUBL $FANDL $FXORL $FJMP $FJLE $FJL $FJE $FJNE $FJGE $FJG /;

our (
    $IHALT, $INOP, $IRRMOVL, $IIRMOVL, $IRMMOVL, $IMRMOVL,
    $IOPL,  $IJXX, $ICALL,   $IRET,    $IPUSHL,  $IPOPL
) = ( 0 .. 0xB );

our ( $FADDL, $FSUBL, $FANDL, $FXORL ) = ( 0 .. 3 );
our ( $FJMP, $FJLE, $FJL, $FJE, $FJNE, $FJGE, $FJG ) = ( 0 .. 6 );
1;
