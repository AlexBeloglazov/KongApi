package KongApi::Roles::AddUpdatable;

use Moo::Role;
use Carp qw(croak);
use KongApi::Helpers;


sub add_update {
    my ($self, %args) = (shift, @_);
    my (%req_body, $val);
    foreach ($self->attr) {
		$val = $args{$_} || $self->{$_};
        $req_body{$_} = $val if defined $val;
    }
    my $res = $self->ua->request(
        type => 'PUT',
        path => $self->path,
        data => \%req_body,
    );
    if ($res->is_success) {
        $self->$_($res->data->{$_}) foreach (keys %{$res->data});
    }
    exec_callback($args{on_success}, $args{on_error}, $res, $self);
    return ($res->is_success) ? $self : undef;
}

1;