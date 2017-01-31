package KongApi::Helpers;

use Carp qw(croak confess);
use parent ("Exporter");

our @EXPORT = ("exec_callback", "args_check");

sub exec_callback {
    my ($on_success, $on_error, $res) = (shift, shift, shift);
    my $callback = ($res->is_success) ? $on_success : $on_error;
    if (defined $callback) {
        (ref $callback eq 'CODE') ? $callback->($res->code) : confess 'Subroutine is expected';
    }
}

sub args_check {
    return (scalar @_ % 2 == 0) ? @_ : confess 'Even number of arguments is expected';
}

1;
