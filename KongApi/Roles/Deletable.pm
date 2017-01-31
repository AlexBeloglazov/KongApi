package KongApi::Roles::Deletable;

use Moo::Role;
use Carp qw(croak);
use KongApi::Helpers;

sub delete {
    my ($self, %args) = (shift, @_);
    my $nameOrId = $self->{id} || $self->{name} || $self->{username} || croak 'Name and ID are undefined';
    my $res = $self->ua->request(
        type => 'DELETE',
        path => $self->path."\/$nameOrId",
    );
    exec_callback($args{on_success}, $args{on_error}, $res, $self);
    return $res->is_success;
}

1;