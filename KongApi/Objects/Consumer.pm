package KongApi::Objects::Consumer;

use Moo;
with map {'KongApi::Roles::'.$_} qw(Addable Deletable Updatable AddUpdatable);

use constant path => 'consumers';
use constant attr => qw(username created_at id custom_id);
use constant updatable => qw(username custom_id);

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
