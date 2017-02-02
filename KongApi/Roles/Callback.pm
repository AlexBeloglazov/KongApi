package KongApi::Roles::Callback;

use Moo::Role;
use Carp qw(confess);


sub _exec_on_success {
	my ($self, $on_success, $res, $object) = @_;
	return unless defined $on_success;
    (ref $on_success eq 'CODE') ? $on_success->($object, $res) : confess 'CODE is expected for callback';
}

sub _exec_on_error {
	my ($self, $on_error, $res, $object) = @_;
	return unless defined $on_error;
    (ref $on_error eq 'CODE') ? $on_error->($res) : confess 'CODE is expected for callback';
}

1;