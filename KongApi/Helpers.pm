package KongApi::Helpers;

use Carp qw(confess);
use parent ("Exporter");

our @EXPORT = ("exec_callback", "args_check");

sub exec_callback {
    my ($on_success, $on_error, $res, $object) = @_;
    my $callback = ($res->is_success) ? $on_success : $on_error;
    return unless $callback;
    if ($res->is_success) {
        (ref $callback eq 'CODE') ? $callback->($object, $res) : confess 'CODE is expected';
    }
    else {
        (ref $callback eq 'CODE') ? $callback->($res) : confess 'CODE is expected';
    }
}

sub args_check {
    return (scalar @_ % 2 == 0) ? @_ : confess 'Even number of arguments is expected';
}

1;
