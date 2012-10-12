# lib/Tower/Assembler/AST.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

package statement_list;

sub statemeng_list {
    my $self = shift;
    if ( !exists $self->{statemeng_list} ) {
        my $rlist = $self->{'statement(s)'};
        return nil->new if not $rlist;
        my @statements = @$rlist;
        my $statement  = pop @statements;
        my $statemeng_list;
        if (@statements) {
            $statemeng_list = bless { 'statement(s)' => \@statements },
              ref $self;
        }
        else {
            $statemeng_list = nil->new;
        }
        $self->{statemeng_list} = $statemeng_list;
        $self->{statement}      = $statement;
    }
    return $self->{statemeng_list};
}

package nil;

sub new {
    bless {}, shift;
}

1;
