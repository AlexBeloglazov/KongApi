package KongApi::UserAgent;

use Moo;
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
    $self->host->path($args{path});
    my $req = HTTP::Request->new($args{type}, $self->host->canonical);
    unless ($args{type} =~ m/GET|DELETE/i) {
        $req->header('Content-Type' => 'application/json');
        $req->content(encode_json $args{data});
    }
    my $res = $self->ua->request($req);
    my $json = eval { decode_json($res->decoded_content || '{}') };
    return KongApi::Response->new({code => $res->code, message => $res->message, json => $@ ? {} : $json});
}

1;
