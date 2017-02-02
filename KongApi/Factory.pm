package KongApi::Factory;

use Moo;
with ('KongApi::Roles::Callback');
use KongApi::Objects::API;
use KongApi::Objects::Plugin;
use KongApi::Objects::Consumer;
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
    my ($on_success, $on_error, $api_name) = (delete $args{on_success}, delete $args{on_error}, delete $args{api_name});
    my $path = (defined $api_name) ? do {delete $args{api_id}; "apis\/$api_name\/".lc $self->type.'s'} : lc $self->type.'s';
    my $res = $self->ua->request(
        type => 'GET',
        path => $path,
        querystring => \%args
    );
    my $data = [map { ('KongApi::Objects::'.$self->type)->new(ua => $self->ua, %$_) } @{$res->data->{data}}];
    if ($res->is_success) {
        $self->_exec_on_success($on_success, $res, $data);
    }
    else {
        $self->_exec_on_error($on_error, $res, $data)
    }
    return $data;
}

sub findOne {
    my ($self, %args) = (shift, @_);
    my $target = ($self->type eq 'Plugin') ? ($args{id} || croak 'Required parameter: id') :
        ($args{id} || $args{name} || $args{username} || croak "Required parameter: id, name or username");
    my ($on_success, $on_error) = (delete $args{on_success}, delete $args{on_error});
    my $res = $self->ua->request(
        type => 'GET',
        path => lc $self->type."s\/$target"
    );
    my $data = ('KongApi::Objects::'.$self->type)->new(ua => $self->ua, %{$res->data});
    if ($res->is_success) {
        $self->_exec_on_success($on_success, $res, $data);
        return $data;
    }
    $self->_exec_on_error($on_error, $res, $data);
    return undef;
}

1;
