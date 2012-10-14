# lib/Tower/Assembler/AST.pm
# Copyright (c) 2012 terrencehan
# hanliang1990@gmail.com

use strict;
use warnings;

package statement_list;

sub statement_list {
    my $self = shift;
    if ( !exists $self->{statement_list} ) {
        my $rlist = $self->{'statement(s)'};
        return nil->new if not $rlist;
        my @statements = @$rlist;
        my $statement  = pop @statements;
        my $statement_list;
        if (@statements) {
            $statement_list = bless { 'statement(s)' => \@statements },
              ref $self;
        }
        else {
            $statement_list = nil->new;
        }
        $self->{statement_list} = $statement_list;
        $self->{statement}      = $statement;
    }
    return $self->{statement_list};
}

package statement;

sub child {
    my $self = shift;
    while ( my ( $key, $val ) = each %$self ) {
        next if $key =~ /[A-Z]/;
        next if $key eq 'nil';

        #warn "$key - $val";
        #warn "Child of $self set to $key: $val";
        return $val;
    }
    $self->{nil};
}

package rmmovl;

sub number {
    my $self = shift;
    if ( $self->{'number(?)'}->[0] ) {
        return $self->{'number(?)'}[0];
    }
    else {
        return eight_zero->new;
    }
}

package mrmovl;

sub number {
    my $self = shift;
    if ( $self->{'number(?)'}->[0] ) {
        return $self->{'number(?)'}[0];
    }
    else {
        return eight_zero->new;
    }
}

package nil;

sub new {
    bless {}, shift;
}

package eight_zero;

sub new {
    bless {}, shift;
}

1;
