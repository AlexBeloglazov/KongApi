package KongApi::Objects::Plugin;

use Moo;

my $path = 'plugins';

my @attr = qw(name created_at id enabled api_id consumer_id config);

has [ @attr ] => (is => 'rw');
has 'ua' => (is => 'ro');



1;
