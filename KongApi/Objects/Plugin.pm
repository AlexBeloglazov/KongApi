package KongApi::Objects::Plugin;

use Moo;
with map {'KongApi::Roles::'.$_} qw(Addable);

use constant path => 'plugins';
use constant attr => qw(name created_at config enabled consumer_id api_id api_name id);


has [ attr ] => (is => 'rw');
has 'ua' => (is => 'ro');

around $_ => sub {
    my ($orig, $self, $val) = @_;
    $orig->($self, $val);
    return $self;
} foreach (attr);


1;
