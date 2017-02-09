# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl KongApi.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;
use Test::More tests => 8;

BEGIN {
	use_ok('KongApi::UserAgent');
	use_ok('KongApi::Factory');
	use_ok('KongApi');
};

my $kong = KongApi->new();
is(
	$kong->ua->server,
	'http://localhost:8001/',
	'testing default server URI'
);

$kong = KongApi->new(server => 'http://www.kongserver.com:8001');
is(
	$kong->ua->server,
	'http://www.kongserver.com:8001',
	'testing correctness of provided server URI'
);

ok(
	$kong->consumer->isa('KongApi::Factory'),
	'testing if Consumer factory exists'
);

ok(
	$kong->plugin->isa('KongApi::Factory'),
	'testing if Plugin factory exists'
);

ok(
	$kong->api->isa('KongApi::Factory'),
	'testing if Api factory exists'
);


#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

