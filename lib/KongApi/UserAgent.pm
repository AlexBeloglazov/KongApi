package KongApi::UserAgent;

use Moo;
use Carp qw(croak);
use URI;
use JSON::PP qw(encode_json decode_json);
use LWP::UserAgent;
use KongApi::Response;

has ua => (is => 'ro');
has server => (is => 'ro', coerce => sub {URI->new($_[0])}, isa => sub {die "URL must be absolute" unless $_[0]->scheme});

sub BUILDARGS {
    my ($class, %args) = @_;
    $args{ua} = LWP::UserAgent->new(timeout => $args{timeout});
    return \%args;
}

sub request {
    my ($self, %args) = @_;
    croak 'Unspecified type of the request' unless defined $args{type};
    $self->server->path($args{path});
    $self->server->query_form($args{querystring}) if exists $args{querystring};
    my $req = HTTP::Request->new($args{type}, $self->server->canonical);
    unless ($args{type} =~ m/GET|DELETE/i) {
        $req->header('Content-Type' => 'application/json');
        $req->content(encode_json $args{data});
    }
    my $res = $self->ua->request($req);
    my $json = eval { decode_json($res->decoded_content || '{}') };
    return KongApi::Response->new({
        code => $res->code,
        message => $res->message,
        data => $@ ? {} : $json,
        is_success => (grep {$_ == $res->code} (200, 201, 204)) ? 1 : 0
    });
}

1;
