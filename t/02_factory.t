use strict;
use warnings;

use Test::MockObject;
use URI;
use JSON::PP qw(decode_json);
use Test::More tests => 20;


BEGIN {
	use_ok('KongApi::Factory')
};

{
	my ($server, $path) = (URI->new('http://kongadmin.com:8001'), 'path');

	my $decoded_json = {
		data => [
			{
				upstream_url => 'http://upstream1.com',
				id => 'id_number1',
				created_at => '1234567890',
				name => 'mock1',
				request_host => 'mock1.com'
			},
			{
				upstream_url => 'http://upstream2.com',
				id => 'id_number2',
				created_at => '234567890',
				name => 'mock2',
				request_host => 'mock2.com'
			}
		]
	};

	my $response = Test::MockObject->new();
	$response->mock('is_success', sub {0});
	$response->mock('data', sub { {} });

	my $ua = Test::MockObject->new();
	$ua->mock(
		'request',
		sub {
			shift;
			my %args = @_;
			$ua->server->path($args{path});
			return $response;
		}
	);
	$ua->mock('server', sub { $server });
	$ua->mock('path', sub { $path });

	my $factory = KongApi::Factory->new(
		build => 1,
		type => 'api',
		ua => $ua
	);
	
	is(
		$factory->type,
		'Api',
		'setting factory type'
	);
	
	ok(
		$factory->new->isa('KongApi::Objects::Api'),
		'object type built by factory'
	);

	ok(
		$factory->ua->can('request'),
		'ua->request'
	);

	is(
		ref $factory->find(api_name => 'mock'),
		'ARRAY',
		'return type of find()'
	);

	is(
		scalar @{$factory->find(api_name => 'mock')},
		0,
		'find() didn\'t find anything'
	);

	is(
		$factory->findOne('id' => 'id_number'),
		undef,
		'undef on unsuccessful findOne()'
	);

	# Successful response returns two results as a string
	$response->mock('is_success', sub{1});
	$response->mock('data',	sub { $decoded_json });

	is(
		scalar @{$factory->find(api_name => 'mock')},
		scalar @{$decoded_json->{data}},
		'find() returns anonymous array of size 2'
	);

	my @data = @{$factory->find(id => 'some_id')};
	foreach my $i (0 .. @{$decoded_json->{data}}-1) {
		foreach (keys %{$decoded_json->{data}->[$i]}) {
			is($data[$i]->$_, $decoded_json->{data}->[$i]->{$_});
		}
	}

	$factory = KongApi::Factory->new(
		build => 1,
		type => 'plugin',
		ua => $ua
	);

	is($factory->type, 'Plugin', 'Plugin factory type');
	$factory->findOne(id => 'some_id');
	is(
		$ua->server,
		'http://kongadmin.com:8001/plugins/some_id',
		'findOne() path correctness'
	);

}

# done_testing();
