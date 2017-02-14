use strict;
use warnings;

use Test::MockObject;
use URI;
use Test::More tests => 40;


BEGIN {
	use_ok('KongApi::Objects::Plugin')
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

my $plugin = KongApi::Objects::Plugin->new(
	ua => $ua,
	id => 'some_id',
	enabled => 'false',
	name => 'plugin_name'
);

is(
	$plugin->id,
	'some_id'
);
is(
	$plugin->enabled,
	'false'
);
is(
	$plugin->name,
	'plugin_name'
);

$response->mock('data', sub { {enabled => 'true'} });
is(
	$plugin->enable,
	1,
	'enable plugin'
);
is(
	$plugin->enabled,
	'true',
	'plugin is enabled'
);

$response->mock('data', sub { {enabled => 'false'} });
is(
	$plugin->disable,
	1,
	'disable plugin'
);
is(
	$plugin->enabled,
	'false',
	'plugin is disabled'
);

# FAIL
$response->mock('is_success', sub { 0 });
is(
	$plugin->enable,
	undef,
	'undef on failure'
);
is(
	$plugin->disable,
	undef,
	'undef on failure'
);
$plugin->delete;
is(
	$request{path},
	'plugins/some_id',
	'request path of delete() when no api_name and api_id'
);

$plugin->api_id('some_api_id');
$plugin->update;
is(
	$plugin->ua->server->path,
	'/apis/some_api_id/plugins/some_id',
	'request path for update()'
);

my $callback_indicator = 1;
is (
	$plugin->delete(on_error => sub {$callback_indicator = 0}),
	0,
	'null on unsuccessful delete()'
);
is(
	$request{type},
	'DELETE',
	'request type of delete()'
);
is(
	$request{path},
	'apis/some_api_id/plugins/some_id'
);
is(
	$callback_indicator,
	0,
	'on_error callback when unsuccess'
);
$callback_indicator = 1;
$response->mock(
	'data', sub {
		{
			name => 'added_name',
			created_at => 'today',
			config => {c1 => 'true', c2 => 'false'},
			enabled => 'true',
			id => 'newly_created_id'
		}
	}
);
is(
	$plugin->add(on_error => sub {$callback_indicator = 0}),
	undef,
	"return undef on unsuccessful add()"
);
is(
	$callback_indicator,
	0,
	'on_error callback on unsuccessful add()'
);
$callback_indicator = 1;
is(
	$plugin->add_update(on_error => sub {$callback_indicator = 0}),
	undef,
	"return undef on unsuccessful add_update()"
);
is(
	$callback_indicator,
	0,
	'on_error callback on unsuccessful add_update()'
);
is(
	$request{type},
	'PUT',
	'request type of add_update()'
);
is(
	$request{path},
	'apis/some_api_id/plugins',
	'request path of add_update()'
);


# SUCCESS
$response->mock('is_success', sub { 1 });
is (
	$plugin->delete(on_success => sub {$callback_indicator = 1}),
	1,
	'return 1 on successful delete()'
);
is(
	$callback_indicator,
	1,
	'on_success callback on successful delete()'
);
$callback_indicator = 0;
isa_ok(
	$plugin->add(on_success => sub {$callback_indicator = 1}),
	'KongApi::Objects::Plugin'
);
is(
	$callback_indicator,
	1,
	'on_success callback on successful add()'
);
foreach (keys %{$response->data}) {
	unless ($_ eq 'config') {
		is(
			$plugin->$_,
			$response->data->{$_}
		);	
	}
}
is(
	$plugin->config->{c1},
	'true'
);
is(
	$plugin->config->{c2},
	'false'
);

$callback_indicator = 0;
$plugin = KongApi::Objects::Plugin->new(
	ua => $ua,
	id => 'some_id',
	enabled => 'false',
	name => 'plugin_name'
);
isa_ok(
	$plugin->add_update(on_success => sub {$callback_indicator = 1}),
	'KongApi::Objects::Plugin'
);
is(
	$callback_indicator,
	1,
	'on_success callback on successful add_update()'
);
foreach (keys %{$response->data}) {
	unless ($_ eq 'config') {
		is(
			$plugin->$_,
			$response->data->{$_}
		);	
	}
}
is(
	$plugin->config->{c1},
	'true'
);
is(
	$plugin->config->{c2},
	'false'
);