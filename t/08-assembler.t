#line t/08-assembler.t
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

use lib '../lib';
use Test::Base;

plan tests => 1 + blocks();

use_ok('Tower::Assembler');

run {
    my $block = shift;
    is translate( $block->src ), $block->byte_code;
};

#print translate(".long 0x4 .pos 0x9 L1: jmp L1")."\n";


#============temp
if (0) {
    use Data::Dump qw/dump/;
    my $src = <<end;
    .pos 0xab4
    .long 0xa34
    .align 4
end

    my $parser = Tower::Assembler::Parser->new;

    dump $parser->program($src);

}



__DATA__
=== Test1:
--- src
halt
--- byte_code: 00

=== Test2:
--- src
nop
--- byte_code: 01

=== Test3:
--- src
ret
--- byte_code: 90 

--- src
rrmovl %eax, %ebx #comment
--- byte_code: 2003

=== Test5:
--- src
irmovl $4, %ebx
--- byte_code: 30f300000004

=== Test6:
--- src
irmovl $-1, %ebx
--- byte_code: 30f3ffffffff

=== Test7:
--- src
irmovl $-4, %ebx
--- byte_code: 30f3fffffffc

=== Test8:
--- src
irmovl STACK, %ebx
--- byte_code: 30f3STACK

=== Test9:
--- src
rmmovl  %eax, -4(%ebx)
--- byte_code: 4003fffffffc

=== Test10:
--- src
rmmovl  %eax, 4(%ebx)
--- byte_code: 400300000004

=== Test11:
--- src
mrmovl -4(%ebx), %eax
--- byte_code: 5003fffffffc

=== Test12:
--- src
pushl %eax
--- byte_code: a00f

=== Test13:
--- src
popl %eax
--- byte_code: b00f

=== Test14:
--- src
call Main
--- byte_code: 80Main

=== Test15:
--- src
addl %eax, %ebx
--- byte_code: 6003

=== Test16:
--- src
subl %eax, %ebx
--- byte_code: 6103

=== Test17:
--- src
andl %eax, %ebx
--- byte_code: 6203

=== Test18:
--- src
xorl %ebx, %eax
--- byte_code: 6330

=== Test19:
--- src
jmp L1
--- byte_code: 70L1

=== Test20:
--- src
jle L1
--- byte_code: 71L1

=== Test21:
--- src
jl L1
--- byte_code: 72L1

=== Test22:
--- src
je L1
--- byte_code: 73L1

=== Test23:
--- src
jne L1
--- byte_code: 74L1

=== Test24:
--- src
jge L1
--- byte_code: 75L1

=== Test25:
--- src
jg L1   #comment
--- byte_code: 76L1

=== Test26:
--- src
.long 0x1
--- byte_code: 00000001

=== Test27:
--- src
.byte 0x1
--- byte_code: 01

=== Test28:
--- src
.word 0xf
--- byte_code: 000f

=== Test29:
--- src
.word 0xf
.align 4
.word 0xf
.align 4
--- byte_code: 000f0000000f0000

=== Test30:
--- src
	.pos 0x0 
init:	irmovl Stack, %esp  
	irmovl Stack, %ebp  
	call Main	
	halt	

	.align 4 	
array:	.long 0xd
	.long 0xc0
	.long 0xb00
	.long 0xa000	

Main:	pushl %ebp 
	rrmovl %esp,%ebp
	irmovl $4,%eax	
	pushl %eax	
	irmovl array,%edx
	pushl %edx  
	call Sum
	rrmovl %ebp,%esp
	popl %ebp
	ret 

Sum:	pushl %ebp
	rrmovl %esp,%ebp
	mrmovl 8(%ebp),%ecx 
	mrmovl 12(%ebp),%edx	
	xorl %eax,%eax	
	andl   %edx,%edx
	je     End
Loop:	mrmovl (%ecx),%esi
	addl %esi,%eax 
	irmovl $4,%ebx
	addl %ebx,%ecx 
	irmovl $-1,%ebx	
	addl %ebx,%edx   
	jne    Loop             
End:	rrmovl %ebp,%esp
	popl %ebp
	ret

	.pos 0x100		
Stack:	 
--- byte_code: 30f40000010030f50000010080000000240000000000000d000000c000000b000000a000a05f204530f000000004a00f30f200000014a02f80000000422054b05f90a05f204550150000000850250000000c630062227300000078506100000000606030f300000004603130f3ffffffff6032740000005b2054b05f90
