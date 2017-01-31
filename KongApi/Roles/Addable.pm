package KongApi::Roles::Addable;

use Moo::Role;
use Carp qw(croak);
use KongApi::Helpers;

sub add {
    my ($self, %args) = (shift, @_);
    my %req_body;
    foreach ($self->attr) {
        $req_body{$_} = $self->{$_} if defined $self->{$_};
    }
    my $res = $self->ua->request(
        type => 'POST',
        path => $self->path,
        data => \%req_body,
    );
    exec_callback($args{on_success}, $args{on_error}, $res, $self);
    return ($res->is_success) ? $self : undef;
}

1;