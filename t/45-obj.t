use warnings;
use strict;

use Carp;
use IPC::Shareable;
use Test::More;

my $t  = 1;
my $ok = 1;

{
    package Dummy;
    
    sub new {
        my $d = {
            _first  => undef,
            _second => undef,
        };
        return bless $d => shift;
    }

    sub first {
        my $self = shift;
        $self->{_first} = shift if @_;
        return $self->{_first};
    }

    sub second {
        my $self = shift;
        $self->{_second} = shift if @_;
        return $self->{_second};
    }
}

tie my $d, 'IPC::Shareable', { destroy => 'yes' };

$d = Dummy->new or undef $ok;
is ref($d), 'Dummy', "shared var is a Dummy object ok";

is $d->first('first'), 'first', "shared obj first() returns ok";
is $d->second('second'), 'second', "shared obj second() returns ok";

is $d->first('foo'), 'foo', "shared obj first() returns ok, again";
is $d->second('bar'), 'bar', "shared obj second() returns ok, again";

done_testing();

