package KongApi::Factory;

use Moo;
use KongApi::Objects::API;
use KongApi::Objects::Plugin;
use KongApi::Objects::Consumer;
use KongApi::Helpers;
use Carp qw(croak);

has [qw (type ua)] => (is => 'ro');

around 'new' => sub {
    my ($orig, $class, %args) = (shift, shift, @_);
    if (exists $args{'build'}) {
        croak 'Too few arguments to build a factory' unless defined $args{type} and defined $args{ua};
        $args{type} =~ s/^(\w+)/\L\u$1/;
        return $orig->($class, %args);
    }
    croak 'Factory must be built first' unless ref $class;
    return ('KongApi::Objects::'.$class->type)->new(ua => $class->ua, %args);
};

sub build {
    my ($class, %args) = (shift, @_);
    $args{build} = 1;
    return __PACKAGE__->new(%args);
}

sub find {
    my ($self, %args) = (shift, @_);
    my ($on_success, $on_error) = (delete $args{on_success}, delete $args{on_error});
    my $res = $self->ua->request(
        type => 'GET',
        path => lc $self->type.'s',
        querystring => \%args
    );
    my $data = [map { ('KongApi::Objects::'.$self->type)->new(ua => $self->ua, %$_) } @{$res->data->{data}}];
    exec_callback($on_success, $on_error, $res, $data);
    return $data;
}

sub findOne {
    my ($self, %args) = (shift, @_);
    my $target = $args{id} || $args{name} || $args{username} || croak "Required parameter: id, name or username";
    my ($on_success, $on_error) = (delete $args{on_success}, delete $args{on_error});
    my $res = $self->ua->request(
        type => 'GET',
        path => lc $self->type."s\/$target"
    );
    my $data = ('KongApi::Objects::'.$self->type)->new(ua => $self->ua, %{$res->data});
    exec_callback($on_success, $on_error, $res, $data);
    return ($res->is_success) ? $data : undef;
}

1;
