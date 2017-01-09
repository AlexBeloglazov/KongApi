package KongApi::Response;

use Moo;

has [qw(code message json)] => (is => 'ro');

1;
