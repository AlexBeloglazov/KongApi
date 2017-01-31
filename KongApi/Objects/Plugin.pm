package KongApi::Objects::Plugin;

use Moo;

has [qw(name created_at id enabled api_id consumer_id config ua)] => (is => 'ro');


1;
