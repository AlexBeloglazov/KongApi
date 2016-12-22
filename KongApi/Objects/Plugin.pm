package KongApi::Objects::Plugin;

use 5.006;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $object = {@_};
	return bless $object, $class;
}

sub name {
	return shift->{name};
}

sub created_at {
	return shift->{created_at};
}

sub enabled{
	return shift->{enabled};
}

sub id {
	return shift->{id};
}

sub api_id {
	return shift->{api_id};
}

sub consumer_id {
	return shift->{consumer_id};
}

sub config {
	return shift->{config};
}

1;