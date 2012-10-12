# 03-tool-complement.t
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

use lib '../lib';
use Test::More 'no_plan';

BEGIN { use_ok('Tower::Tool::Complement'); }

my @t = ( -9, -1, 0, 1, 9, 100 );
use Tower::Tool::Complement qw(to_decimal);

for (@t) {
    my $str = sprintf "%.8x", $_;
    $str = substr( $str, 8 ) if length($str) > 8;
    is to_decimal($str), $_;
}
