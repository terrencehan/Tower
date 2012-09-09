package Tower::VM::Memory;

use Tower::Tool::Complement;

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

}

1;
