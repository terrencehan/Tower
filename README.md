Tower - An assembly language simulator with a VM.
=========================
Here is an experimental implementation of a simple assembly language simulator.
###Components:
* Tower Assembler 
* Tower Virtual Machine 
* 
With given source, the simulator can run and print results step-by-step.

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



INSTALLATION
------------------------

To install this module type the following:

    perl Makefile.PL
    make
    make test
    make install

USAGE
------------------------
###Assembler

    perl -Ilib script/as sample/sample0.ts

Now, temporarily, only the last status of Tower-VM-CPU is printed on STDOUT. Later Tower assembler will support IO instructions, or I might add IO module inside Tower VM and use interrupt to accomplish this function.


DEPENDENCIES
------------------------

This module requires these other modules and libraries:

* Parse::RecDescent
* Language::AttributeGrammar



COPYRIGHT AND LICENCE
------------------------


Copyright (C) 2012 by terrencehan (hanliang1990@gmail.com)

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


