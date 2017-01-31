use v5.10;
use strict;
use Data::Dumper;

use KongApi;
use JSON::PP qw(encode_json decode_json);
use URI::URL;
use LWP::UserAgent;

my $k = KongApi->new(server => 'http://192.168.0.2:8001', ua_timeout => 5);
# my $k2 = KongApi->new(server => 'http://192.168.0.2:8001', ua_timeout => 5);

# print $k->ua, $k2->ua;
# $k->getApis();
# print Dumper($k->getApis()->[0]->upstream_url), "\n";
# print Dumper($k->deleteConsumer(username => 'noxik2'));

print Dumper $k->api->new(name => 'mockbin2', upstream_url => 'http://mockbin.com/', request_host => 'mockbin.com')->add;

# print Dumper $k->consumer->findOne(id => 'bf9b866b-5c88-4200-b0ac-43ff166790e4')->data->create_update(username => 'meagain');


# my $api = $k->api->findOne(id => '514b39d6-ab77-45fa-acc2-bbe327eb5b91')->data;
# $api->name('mockbin');

# print Dumper $api->delete(on_success => sub {
#     say "success";
# });
#
# print Dumper $api->delete(on_error => sub {
#     say 'error code: ' . shift;
# });

# $api->update(name => '', on_success => sub {})
