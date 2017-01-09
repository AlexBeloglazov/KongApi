package KongApi::Objects::API;

use Moo;
use 5.006;

has [qw(name created_at id request_host request_path strip_request_path preserve_host upstream_url)] => (is => 'ro');

1;
