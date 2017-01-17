package KongApi::Factory;

use Moo;
use Data::Dumper;
use KongApi::Response;
require KongApi::Objects::API;
require KongApi::Objects::Plugin;
require KongApi::Objects::Consumer;
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
    return ('KongApi::Objects::'.$class->type)->new(ua => $class->ua);
};

sub build {
    my ($class, %args) = (shift, @_);
    $args{build} = 1;
    return __PACKAGE__->new(%args);
}

sub find {
    my ($self, %args) = (shift, @_);
    my $res = $self->ua->request(type => 'GET', path => lc $self->type.'s', querystring => \%args);
    return KongApi::Response->new({
        code => $res->code, message => $res->message, is_success => $res->is_success,
        data => [map { ('KongApi::Objects::'.$self->type)->new(ua => $self->ua, %$_) } @{$res->data->{data}}]
    });
}

sub findOne {
    my ($self, %args) = (shift, @_);
    my $target = $args{id} || $args{name} || $args{username};
    croak "Required request parameter: id, name or username" unless $target;
    my $res = $self->ua->request(type => 'GET', path => lc $self->type."s\/$target");
    return KongApi::Response->new({
        code => $res->code, message => $res->message, is_success => $res->is_success,
        data => ('KongApi::Objects::'.$self->type)->new(ua => $self->ua, %{$res->data})
    });
}

1;