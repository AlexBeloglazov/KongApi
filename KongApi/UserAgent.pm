package KongApi::UserAgent;

use Moo;
use Carp qw(croak confess);
use URI;
use JSON::PP qw(encode_json decode_json);
use LWP::UserAgent;
use Data::Dumper;
use KongApi::Response;

has ua => (is => 'ro');
has host => (is => 'ro', coerce => sub {URI->new($_[0])}, isa => sub {die "URL must be absolute" unless $_[0]->scheme});

sub BUILDARGS {
    my ($class, %args) = @_;
    $args{ua} = LWP::UserAgent->new(timeout => $args{timeout});
    return \%args;
}

sub request {
    my ($self, %args) = @_;
    croak 'Unspecified type of the request' unless defined $args{type};
    $self->host->path($args{path});
    $self->host->query_form($args{querystring}) if exists $args{querystring};
    my $req = HTTP::Request->new($args{type}, $self->host->canonical);
    unless ($args{type} =~ m/GET|DELETE/i) {
        $req->header('Content-Type' => 'application/json');
        $req->content(encode_json $args{data});
    }
    my $res = $self->ua->request($req);
    my $json = eval { decode_json($res->decoded_content || '{}') };
    my $response = KongApi::Response->new({
        code => $res->code,
        message => $res->message,
        data => $@ ? {} : $json,
        is_success => (grep {$_ == $res->code} (200, 201, 204)) ? 1 : 0
    });
    my $callback = ($response->is_success) ? $args{on_success} : $args{on_error};
    if (defined $callback) {
        (ref $callback eq 'CODE') ? $callback->($response->code) : confess 'Subroutine is expected';
    }
    return $response;
}

1;
