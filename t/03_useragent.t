use strict;
use warnings;

use Test::MockObject;
use Test::MockModule;
use URI;
use Test::More tests => 14;


BEGIN {
	use_ok('KongApi::UserAgent');
	use_ok('KongApi::Response');
};

# Mock module, mock object

my $response = {
	code => 200,
	message => 'Message',
	decoded_content => "\{\"data\": \"content\"\}",
};
my $ua_res_object = Test::MockObject->new();
$ua_res_object->mock('code', sub { $response->{code} });
$ua_res_object->mock('message', sub { $response->{message} });
$ua_res_object->mock('decoded_content', sub { $response->{decoded_content} });

my $timeout = 0;
my $request;
my $ua_module = Test::MockModule->new('LWP::UserAgent');
$ua_module->mock(
	'new',
	sub {
		my ($self, %args) = (shift, @_);
		$timeout = $args{timeout};
		return $self;
	}
);
$ua_module->mock('request', sub { shift; $request = shift; $ua_res_object });
$ua_module->mock('timeout', sub { $timeout });

# TEST

my $UserAgent = KongApi::UserAgent->new(
	ua => $ua_module,
	server => 'http://kongadmin.com:8001',
	timeout => 5
);
is(
	$UserAgent->ua->timeout,
	5,
	'ua timeout option'
);

$UserAgent->request(
	type => 'GET',
	path => 'check_path'	
);
is(
	$request->method,
	'GET',
	'GET method of the request'
);
is(
	$request->uri,
	$UserAgent->server,
	'path of the request'
);

my $kong_response = $UserAgent->request(
	type => 'POST',
	path => 'check_path',
	data => {}
);
is(
	$request->method,
	'POST',
	'POST method of the request'
);
is(
	$request->header('Content-Type'),
	'application/json',
	'content-type header'
);
is(
	$kong_response->code,
	200,
	'correct code of kong response'
);
is(
	$kong_response->message,
	'Message',
	'correct message of kong response'
);
is(
	$kong_response->data->{data},
	'content',
	'correct payload of kong response'
);
is(
	$kong_response->is_success,
	1,
	'successful kong response'
);

$response->{code} = 400;
$kong_response = $UserAgent->request(
	type => 'POST',
	path => 'check_path',
	data => {}
);
is(
	$kong_response->is_success,
	0,
	'unsuccessful kong response'
);

$ua_res_object->mock('decoded_content', sub { '' });
$kong_response = $UserAgent->request(
	type => 'POST',
	path => 'check_path',
	data => {},
	querystring => {arg1 => 1, arg2 => 2}
);
is(
	scalar keys %{$response->{data}},
	0,
	'empty payload'
);
is(
	$request->uri,
	'http://kongadmin.com:8001/check_path?arg1=1&arg2=2',
	'querystring correctness'
);