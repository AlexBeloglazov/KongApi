package KongApi::Objects::Plugin;

use Moo;
with map {'KongApi::Roles::'.$_} qw(Addable Deletable Updatable AddUpdatable Callback);

use constant path => 'plugins';
use constant attr => qw(name created_at config enabled consumer_id api_id api_name id);

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

sub disable {
    return (shift->enabled('false')->update) ? 1 : undef;
}

sub enable {
    return (shift->enabled('true')->update) ? 1 : undef;
}

1;
