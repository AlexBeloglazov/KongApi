package KongApi::Objects::API;

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

sub id {
	return shift->{id};
}

sub created_at {
	return shift->{created_at};
}

sub request_host{
	return shift->{request_host};
}

sub request_path{
	return shift->{request_path};
}

sub strip_request_path{
	return shift->{strip_request_path};
}

sub preserve_host{
	return shift->{preserve_host};
}

sub upstream_url{
	return shift->{upstream_url};
}

1;