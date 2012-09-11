#use strict;
#use warnings;

use lib '../lib';
use Test::More 'no_plan';

BEGIN { use_ok ('Tower::Tool::Complement'); };

@t = (-9, -1, 0, 1, 9, 100);
use Tower::Tool::Complement qw(to_decimal);


for (@t){
    $str = sprintf "%x", $_;
    is to_decimal($str), $_;
}
