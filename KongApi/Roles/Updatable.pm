package KongApi::Roles::Updatable;

use Moo::Role;
use Carp qw(croak);

sub update {
    my ($self, %args) = (shift, @_);
    my ($prefix, $target, %new_attr);
    foreach ($self->attr) {
        $new_attr{$_} = $self->$_ if $self->$_;
    }
    if ($self->isa('KongApi::Objects::Plugin')) {
        $target = $self->id || croak 'id must be defined';
        my $nameOrId = delete $new_attr{api_name} || $self->api_id;
        $prefix = ($nameOrId) ? "apis\/$nameOrId\/" : '';
    }
    else {
        $target = $self->id || $self->name || $self->username || croak 'name or id must be defined';
    }
    my $res = $self->ua->request(
        type => 'PATCH',
        path => "$prefix${\($self->path)}/$target",
        data => \%new_attr,
    );
    if ($res->is_success) {
        $self->$_($res->data->{$_}) foreach ($self->attr);
        $self->_exec_on_success($args{on_success}, $res, $self);
        return $self;
    }
    $self->_exec_on_error($args{on_error}, $res, $self);
    return undef;
}

1;
