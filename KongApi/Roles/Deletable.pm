package KongApi::Roles::Deletable;

use Moo::Role;
use Carp qw(croak);
use KongApi::Helpers;

sub delete {
    my ($self, %args) = (shift, @_);
    my $path;
    if ($self->isa('KongApi::Objects::Plugin')) {
        my $prefix = $self->{api_id} || $self->{api_name};
        $path = (defined $prefix) ? "apis\/$prefix\/".$self->path."\/".$self->{id} : $self->path."\/".$self->{id};
    }
    else {
        my $nameOrId = $self->{id} || $self->{name} || $self->{username} || croak 'name or id must be undefined';
        $path = $self->path."\/$nameOrId";
    }
    my $res = $self->ua->request(
        type => 'DELETE',
        path => $path
    );
    exec_callback($args{on_success}, $args{on_error}, $res, $self);
    return $res->is_success;
}

1;
