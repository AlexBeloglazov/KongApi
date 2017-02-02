package KongApi::Roles::Addable;

use Moo::Role;
use Carp qw(croak);

sub add {
    my ($self, %args) = (shift, @_);
    my (%req_body, $prefix);
    foreach ($self->attr) {
        $req_body{$_} = $self->$_ if $self->$_;
    }
    if ($self->isa('KongApi::Objects::Plugin')) {
        my $nameOrId = delete $req_body{api_name} || $self->api_id;
        $prefix = ($nameOrId) ? "apis\/$nameOrId\/" : '';
    }
    my $res = $self->ua->request(
        type => 'POST',
        path => "$prefix${\($self->path)}",
        data => \%req_body,
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
