package KongApi::Roles::Addable;

use Moo::Role;
use Carp qw(croak);
use KongApi::Helpers;

sub add {
    my ($self, %args) = (shift, @_);
    my (%req_body, $prefix);
    foreach ($self->attr) {
        $req_body{$_} = $self->$_ if defined $self->$_;
    }
    if ($self->isa('KongApi::Objects::Plugin')) {
        croak 'conflicting api_id and api_name' if $self->api_id and (exists $args{api_id} or exists $args{api_name});
        croak 'define either api_id or api_name' if exists $args{api_id} and exists $args{api_name};
        my $nameOrId = $self->api_id || $args{api_id} || $args{api_name};
        $prefix = ($nameOrId) ? "apis\/$nameOrId\/" : '';
    }
    my $res = $self->ua->request(
        type => 'POST',
        path => $prefix . $self->path,
        data => \%req_body,
    );
    if ($res->is_success) {
        $self->$_($res->data->{$_}) foreach ($self->attr);
    }
    exec_callback($args{on_success}, $args{on_error}, $res, $self);
    return ($res->is_success) ? $self : undef;
}

1;
