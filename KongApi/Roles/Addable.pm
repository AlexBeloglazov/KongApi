package KongApi::Roles::Addable;

use Moo::Role;

sub add {
    my ($self, %args) = (shift, @_);
    my %req_body;
    foreach (@attr) {
        $req_body{$_} = $self->$_ if defined $self->$_;
    }
    my $res = $self->ua->request(
        type => 'POST',
        path => $path,
        data => \%req_body,
    );
    exec_callback($args{on_success}, $args{on_error}, $res);
    return ($res->is_success) ? $self : 0;
}

1;
