package KongApi::Objects::Consumer;

use Moo;

has [qw(username created_at id custom_id ua)] => (is => 'ro');

1;
