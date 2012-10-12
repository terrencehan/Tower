# lib/Tower/VM/CPU/SEQ.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

package Tower::VM::CPU::SEQ;

use strict;
use warnings;
use 5.010;

use Tower::VM::CPU;
use Tower::VM::CPU::Constant;
use Tower::Tool::Complement qw/to_decimal/;
use Tower::VM::Memory::Helper qw/
  put_val_in_4bytes
  get_val
  /;

our @ISA = qw/Tower::VM::CPU/;

sub new {
    my $class = shift;
    my $self  = Tower::VM::CPU->new;
    my %hash  = (
        valP  => 0x0,
        valA  => 0x0,
        valB  => 0x0,
        valC  => 0x0,
        valE  => 0x0,
        valM  => 0x0,
        rA    => 0x0,
        rB    => 0x0,
        icode => 0x0,
        ifun  => 0x0,
        %{$self}
    );
    $self = \%hash;
    return bless $self, $class;
}

sub run_next_instruction {
    my ( $self, $mem ) = @_;

    my @six_bytes = $mem->read( $self->{pc}, 6 );
    for (@six_bytes) { $_ = 0 unless defined $_; }
    my ( $icode, $ifun, $rA, $rB, @valC ) = @six_bytes;

    $self->{valC}  = to_decimal( join "", @valC );
    $self->{icode} = hex $icode;
    $self->{ifun}  = hex $ifun;
    $self->{rA}    = hex $rA;
    $self->{rB}    = hex $rB;

# we must test $rA and $rB before passing them 
# to get_r_with_num, because it might be a invalid 
# value to $self->{res_num_to_name}.
    $self->{valA} = $self->get_r_with_num($rA)
      if $self->{rA} <= 7
      or $self->{rA} == 15;
    $self->{valB} = $self->get_r_with_num($rB)
      if $self->{rA} <= 7
      or $self->{rA} == 15;

    given ( $self->{icode} ) {
        when ($INOP)    { $self->handle_nop }
        when ($IHALT)   { $self->handle_halt }
        when ($IRRMOVL) { $self->handle_rrmovl }
        when ($IIRMOVL) { $self->handle_irmovl }
        when ($IRMMOVL) { $self->handle_rmmovl($mem) }
        when ($IMRMOVL) { $self->handle_mrmovl($mem) }
        when ($IOPL)    { $self->handle_opl }
        when ($IJXX)    { $self->handle_jXX($mem) }
        when ($ICALL)   { $self->handle_call($mem) }
        when ($IRET)    { $self->handle_ret($mem) }
        when ($IPUSHL)  { $self->handle_pushl($mem) }
        when ($IPOPL)   { $self->handle_popl($mem) }
    }

}

sub handle_halt {
    my $self = shift;
    $self->{stat} = 123;
}

#sub handle_nop{
#say "handle_nop{";

#}

sub handle_rrmovl {
    my $self = shift;
    $self->{valP} = $self->{pc} + 2;
    $self->{valE} = 0 + $self->{valA};
    $self->put_r_with_num( $self->{rB}, $self->{valE} );
    $self->{pc} = $self->{valP};
}

sub handle_irmovl {
    my $self = shift;
    $self->{valP} = $self->{pc} + 6;
    $self->{valE} = 0 + $self->{valC};
    $self->put_r_with_num( $self->{rB}, $self->{valE} );
    $self->{pc} = $self->{valP};
}

sub handle_rmmovl {
    my ( $self, $mem ) = @_;
    $self->{valP} = $self->{pc} + 6;
    $self->{valE} = $self->{valB} + $self->{valC};

    put_val_in_4bytes( $mem, $self->{valE}, $self->{valA} );
    $self->{pc} = $self->{valP};
}

sub handle_mrmovl {
    my ( $self, $mem ) = @_;
    $self->{valP} = $self->{pc} + 6;
    $self->{valE} = $self->{valB} + $self->{valC};
    $self->{valM} = get_val( $mem, $self->{valE}, 4 );
    $self->put_r_with_num( $self->{rA}, $self->{valM} );
    $self->{pc} = $self->{valP};
}

#sub set_cc{
#}

sub handle_opl {
    my $self = shift;
    $self->{valP} = $self->{pc} + 2;

    given ( $self->{ifun} ) {
        when ($FADDL) { $self->{valE} = $self->{valB} + $self->{valA}; }
        when ($FSUBL) { $self->{valE} = $self->{valB} - $self->{valA}; }
        when ($FANDL) { $self->{valE} = $self->{valB} & $self->{valA}; }
        when ($FXORL) { $self->{valE} = $self->{valB} ^ $self->{valA}; }
    }

    $self->{cc}->{"SF"} = 0;
    $self->{cc}->{"ZF"} = 0;
    $self->{cc}->{"OF"} = 0;
    $self->{cc}->{"OF"} = 1
      if ( $self->{valE} > to_decimal("7fffffff")
        or $self->{valE} < to_decimal("80000000") );
    $self->{cc}->{"ZF"} = 1 if ( $self->{valE} == 0x0 );
    $self->{cc}->{"SF"} = 1 if ( $self->{valE} < 0 );

    $self->put_r_with_num( $self->{rB}, $self->{valE} );
    $self->{pc} = $self->{valP};
}

sub handle_jXX {
    my ( $self, $mem ) = @_;
    $self->{valC} = get_val $mem, $self->{pc} + 1, 4;
    $self->{valP} = $self->{pc} + 5;

    $self->{cnd} = 0;
    given ( $self->{ifun} ) {
        when ($FJMP) { $self->{cnd} = 1 }
        when ($FJLE) {
            $self->{cnd} =
              ( $self->{cc}->{"ZF"} == 1 or $self->{cc}->{"SF"} == 1 )
        }
        when ($FJL) {
            $self->{cnd} =
              ( $self->{cc}->{"ZF"} == 0 and $self->{cc}->{"SF"} == 1 )
        }
        when ($FJE)  { $self->{cnd} = ( $self->{cc}->{"ZF"} == 1 ) }
        when ($FJNE) { $self->{cnd} = ( $self->{cc}->{"ZF"} == 0 ) }
        when ($FJGE) {
            $self->{cnd} =
              ( $self->{cc}->{"ZF"} == 1 or $self->{cc}->{"SF"} == 0 )
        }
        when ($FJG) {
            $self->{cnd} =
              ( $self->{cc}->{"ZF"} == 0 and $self->{cc}->{"SF"} == 0 )
        }
    }

    $self->{pc} = $self->{cnd} ? $self->{valC} : $self->{valP};
}

sub handle_call {
    my ( $self, $mem ) = @_;
    $self->{valC} = get_val $mem, $self->{pc} + 1, 4;
    $self->{valP} = $self->{pc} + 5;
    $self->{valB} = $self->{res}->{"%esp"};
    $self->{valE} = $self->{valB} - 4;

    put_val_in_4bytes $mem, $self->{valE}, $self->{valP};
    $self->{res}->{"%esp"} = $self->{valE};

    $self->{pc} = $self->{valC};
}

sub handle_ret {
    my ( $self, $mem ) = @_;
    $self->{valP} = $self->{pc} + 1;
    $self->{valA} = $self->{res}->{"%esp"};
    $self->{valB} = $self->{res}->{"%esp"};
    $self->{valE} = $self->{valB} + 4;

    $self->{valM} = get_val $mem, $self->{valA}, 4;

    $self->{res}->{"%esp"} = $self->{valE};

    $self->{pc} = $self->{valM};
}

sub handle_pushl {
    my ( $self, $mem ) = @_;
    $self->{valP} = $self->{pc} + 2;
    $self->{valB} = $self->{res}->{"%esp"};
    $self->{valE} = $self->{valB} - 4;
    put_val_in_4bytes $mem, $self->{valE}, $self->{valA};
    $self->{res}->{"%esp"} = $self->{valE};
    $self->{pc} = $self->{valP};
}

sub handle_popl {
    my ( $self, $mem ) = @_;
    $self->{valP}          = $self->{pc} + 2;
    $self->{valA}          = $self->{res}->{"%esp"};
    $self->{valB}          = $self->{res}->{"%esp"};
    $self->{valE}          = $self->{valB} + 4;
    $self->{valM}          = get_val $mem, $self->{valA}, 4;
    $self->{res}->{"%esp"} = $self->{valE};
    $self->put_r_with_num( $self->{rA}, $self->{valM} );
    $self->{pc} = $self->{valP};
}

sub start {
    my ( $self, $mem, $pc_start_position, $show_cpu_info ) = @_;
    my $count = 1;
    $pc_start_position = 0x00 unless ( defined $pc_start_position );
    $self->{pc} = $pc_start_position;
    while ( $self->{stat} != 123 ) {
        $self->run_next_instruction($mem);
        if ($show_cpu_info) {
            $self->print_cpu_info;
            say "----------------------instruction " . $count++ . " done";
        }
    }
}

sub _get_hex_form {
    my $val = shift;
    my $str = sprintf "%.8x", $val;
    $str = substr( $str, 8 ) if length($str) > 8;
    return $str;    #shortroute
    return $val;
}

sub print_cpu_info {
    my $self = shift;
    say "icode: " . _get_hex_form( $self->{icode} );
    say "ifun:  " . _get_hex_form( $self->{ifun} );
    say "rA:    " . _get_hex_form( $self->{rA} );
    say "rB:    " . _get_hex_form( $self->{rB} );
    say "valA:  " . _get_hex_form( $self->{valA} );
    say "valB:  " . _get_hex_form( $self->{valB} );
    say "valC:  " . _get_hex_form( $self->{valC} );
    say "valE:  " . _get_hex_form( $self->{valE} );
    say "valM:  " . _get_hex_form( $self->{valM} );
    say "valP:  " . _get_hex_form( $self->{valP} );
    say "PC:    " . _get_hex_form( $self->{pc} );
    $self->print_cc;
    $self->print_res;
}

1;
