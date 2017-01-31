package KongApi::Roles::Updatable;

use Moo::Role;
use Carp qw(croak);
use KongApi::Helpers;

sub update {
    my ($self, %args) = (shift, @_);
    my $nameOrId = $self->{id} || $self->{name} || $self->{username} || croak 'Name and ID are undefined';
    my (%new_attr, $val);
    foreach ($self->attr) {
        $val = $args{$_} || $self->{$_};
        $new_attr{$_} = $val if defined $val;
    }
    my $res = $self->ua->request(
        type => 'PATCH',
        path => $self->path."\/$nameOrId",
        data => \%new_attr,
    );
    if ($res->is_success) {
        $self->$_($res->data->{$_}) foreach (keys %{$res->data});
    }
    exec_callback($args{on_success}, $args{on_error}, $res, $self);
    return ($res->is_success) ? $self : undef;
}

1;