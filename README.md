Tower - An experiental programming language
=========================
Here is an experimental implementation of a small language named Tower. I write this just for fun, but i really wanna finish it. :)
###Components:
* Tower Compiler
* Tower Assembler *
* Tower Virtual Machine *

(* available now)

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

###Tower compiler
coming soon.


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


