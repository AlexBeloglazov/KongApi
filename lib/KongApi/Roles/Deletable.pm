package KongApi::Roles::Deletable;

use Moo::Role;
use Carp qw(croak);

sub delete {
    my ($self, %args) = (shift, @_);
    my ($prefix, $target);
    if ($self->isa('KongApi::Objects::Plugin')) {
        $target = $self->id || croak 'id must be defined';
        my $nameOrId = $self->api_name || $self->api_id;
        $prefix = ($nameOrId) ? "apis\/$nameOrId\/" : '';
    }
    else {
        $target = $self->id || croak 'id must be defined';
    }
    my $res = $self->ua->request(
        type => 'DELETE',
        path => ($prefix || '' ) . $self->path . "/$target"
    );
    if ($res->is_success) {
        $self->_exec_on_success($args{on_success}, $res, $self);
    }
    else {
        $self->_exec_on_error($args{on_error}, $res, $self)
    }
    return $res->is_success;
}

1;
