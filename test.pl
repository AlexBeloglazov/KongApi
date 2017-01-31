use v5.10;
use strict;
use Data::Dumper;

use KongApi;
use JSON::PP qw(encode_json decode_json);
use URI::URL;
use LWP::UserAgent;

my $k = KongApi->new(server => 'http://127.0.0.1:8001', ua_timeout => 5);
# my $k2 = KongApi->new(server => 'http://192.168.0.2:8001', ua_timeout => 5);


# print Dumper $k->api->new(name => 'mockbin', upstream_url => 'http://mockbin.com/', request_host => 'mockbin.com')->update;

print Dumper $k->plugin->new(name => 'basic-auth', config => {hide_credentials => 'true'}, api_name => "mockbin")->add(on_error => sub {print Dumper shift->data});

# my $found = $k->api->findOne(id => 'edfcaee2-954b-4403-bda6-308fe99fbfc8', on_error => sub {say 'code: '.shift->code});
# if ($found) {
# 	$found->delete(on_success => sub {say 'ok'});
# }

