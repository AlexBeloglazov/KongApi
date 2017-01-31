package KongApi::Objects::Api;

use Moo;
use Carp qw(croak);
use KongApi::Helpers;
use KongApi::Response;

our $path = 'apis';

my @attr = qw(name request_host request_path strip_request_path preserve_host upstream_url created_at id);

has [ @attr ] => (is => 'rw');
has 'ua' => (is => 'ro');

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

sub update {
    my ($self, %args) = (shift, @_);
    my $nameOrId = $self->id || $self->name || croak 'Name and ID are undefined';
    my (%new_attr, $val);
    foreach (@attr) {
        $val = $args{$_} || $self->$_;
        $new_attr{$_} = $val if defined $val;
    }
    my $res = $self->ua->request(
        type => 'PATCH',
        path => "$path\/$nameOrId",
        data => \%new_attr,
    );
    if ($res->is_success) {
        $self->$_($res->data->{$_}) foreach (keys $res->data);
    }
    exec_callback($args{on_success}, $args{on_error}, $res);
    return ($res->is_success) ? $self : 0;
}

sub delete {
    my ($self, %args) = (shift, @_);
    my $nameOrId = $self->id || $self->name || croak 'Name and ID are undefined';
    my $res = $self->ua->request(
        type => 'DELETE',
        path => "$path\/$nameOrId",
    );
    exec_callback($args{on_success}, $args{on_error}, $res);
    return $res->is_success;
}

sub create_update {
    my ($self, %args) = (shift, @_);
    my (%req_body, $val);
    foreach (@attr) {
		$val = $args{$_} || $self->$_;
        $req_body{$_} = $val if defined $val;
    }
    my $res = $self->ua->request(
        type => 'PUT',
        path => $path,
        data => \%req_body,
    );
    if ($res->is_success) {
        $self->$_($res->data->{$_}) foreach (keys $res->data);
    }
    exec_callback($args{on_success}, $args{on_error}, $res);
    return ($res->is_success) ? $self : 0;
}

1;
