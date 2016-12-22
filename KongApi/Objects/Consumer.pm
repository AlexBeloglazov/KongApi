package KongApi::Objects::Consumer;

use 5.006;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $object = {@_};
	return bless $object, $class;
}

sub username {
	return shift->{username};
}

sub created_at {
	return shift->{created_at};
}

sub id {
	return shift->{id};
}

sub custom_id {
	return shift->{custom_id} || '';
}


1;