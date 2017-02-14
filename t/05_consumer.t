use strict;
use warnings;

use Test::MockObject;
use URI;
use Test::More tests => 18;


BEGIN {
	use_ok('KongApi::Objects::Consumer')
};

# Mock objects and helper variables

my $server = URI->new('http://kongadmin.com:8001');
my %request;

my $response = Test::MockObject->new();
$response->mock('is_success', sub {1});
$response->mock('data', sub { {} });

my $ua = Test::MockObject->new();
$ua->mock('server', sub { $server });
$ua->mock(
	'request',
	sub {
		shift;
		%request = @_;
		$ua->server->path($request{path});
		return $response;
	}
);


# TESTS

my $consumer = KongApi::Objects::Consumer->new(
	ua => $ua,
	id => 'some_id',
	username => 'user'
);
$consumer->update;
is(	
	$consumer->username,
	'user',
	'consumer username'
);
is(	
	$request{data}->{username},
	'user',
	'update() request data'
);
is(	
	$request{path},
	'consumers/some_id',
	'udpate() request path'
);

$response->mock('data', sub { {username => 'new_name'} });
$consumer->update;
is(
	$consumer->username,
	'new_name',
	'update username'
);
is(	
	$request{type},
	'PATCH',
	'update() request method'
);

my $callback_indicator = 0;
is(
	$consumer->delete(on_success => sub {$callback_indicator = 1}),
	1,
	'return 1 on successful delete()'
);
is(
	$callback_indicator,
	1,
	'on_success callback on delete()'
);
is(
	$request{path},
	'consumers/some_id',
	'delete() request path'
);

$response->mock('is_success', sub {0});
is(
	$consumer->update,
	undef,
	'undef on unsuccessful update()'
);
is(
	$consumer->delete(on_error => sub {$callback_indicator = 0}),
	0,
	'rerurn 0 on unsuccessful delete()'
);
is(
	$callback_indicator,
	0,
	'on_error callback on delete()'
);

$response->mock(
	'data', 
	sub {
		{
			username => 'added_username',
			created_at => 'today',
			id => 'given_id',
			custom_id => 'custom_id'
		}
	}
);
$response->mock('is_success', sub {1});
isa_ok(
	$consumer->add,
	'KongApi::Objects::Consumer'
);
foreach (keys %{$response->data}) {
	is(
		$consumer->$_,
		$response->data->{$_}
	);
};
$consumer->add_update;
is(
	$request{path},
	'consumers',
	'request path on add_update()'
);