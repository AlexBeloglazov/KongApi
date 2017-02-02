package KongApi::Roles::Updatable;

use Moo::Role;
use Carp qw(croak);
use KongApi::Helpers;

sub update {
    my ($self, %args) = (shift, @_);
    my ($path, %new_attr);
    if ($self->isa('KongApi::Objects::Plugin')) {
        croak 'id attribute must be defined' unless $self->{id};
        $path = ($self->api_id) ? 'apis/'.$self->api_id.'/'.$self->path.'/'.$self->{id} : $self->path.'/'.$self->{id};
    }
    else {
        my $nameOrId = $self->id || $self->name || $self->username || croak 'name or id must be defined';
        $path = $self->path."\/$nameOrId";
    }
    foreach ($self->updatable) {
        $new_attr{$_} = $self->$_ if $self->$_;
    }
    my $res = $self->ua->request(
        type => 'PATCH',
        path => $path,
        data => \%new_attr,
    );
    if ($res->is_success) {
        $self->$_($res->data->{$_}) foreach (keys %{$res->data}); # might need to be changed
    }
    exec_callback($args{on_success}, $args{on_error}, $res, $self);
    return ($res->is_success) ? $self : undef;
}

1;
