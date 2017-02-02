package KongApi::Objects::Api;

use Moo;
with map {'KongApi::Roles::'.$_} qw(Addable Deletable Updatable AddUpdatable Callback);

use constant path => 'apis';
use constant attr => qw(name request_host request_path strip_request_path preserve_host upstream_url created_at id);

has [ attr ] => (is => 'rw');
has 'ua' => (is => 'ro');

around $_ => sub {
    my ($orig, $self, $val) = @_;
    if (defined $val) {
        $orig->($self, $val);
        return $self;
    }
    else {
        return $orig->($self);
    }
} foreach (attr);


1;
