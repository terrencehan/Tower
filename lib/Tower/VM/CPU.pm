use strict;
use warnings;
package Tower::VM::CPU;

our ($IHALT, $INOP, $IRRMOVL, $IIRMOVL, $IRMMOVL, $IMRMOVL, $IOPL, $IJXX, $ICALL, $IRET, $IPUSHL, $IPOPL) = (0 .. 0xB);
our ($FADDL, $FSUBL, $FANDL, $FXORL) = (0 .. 3); 
our ($FJMP, $FJLE, $FJL, $FJE, $FJNE, $FJGE, $FJG) = (0 .. 6);


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
        stat=> 0x00, 
        pc  => 0x00, 
    };
    return bless $self, $class;
}

1;
