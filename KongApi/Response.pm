package KongApi::Response;

use Moo;

has [qw(code message data is_success)] => (is => 'ro');

1;
