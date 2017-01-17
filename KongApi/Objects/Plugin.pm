package KongApi::Objects::Plugin;

use Moo;
use 5.006;

has [qw(name created_at id enabled api_id consumer_id config ua)] => (is => 'ro');


1;
