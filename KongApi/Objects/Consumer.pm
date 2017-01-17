package KongApi::Objects::Consumer;

use Moo;
use 5.006;

has [qw(username created_at id custom_id ua)] => (is => 'ro');

1;
