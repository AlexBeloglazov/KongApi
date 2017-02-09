use v5.10;
use strict;
use Data::Dumper;

use KongApi;
use JSON::PP qw(encode_json decode_json);
use URI::URL;
use LWP::UserAgent;

my $k = KongApi->new(server => 'http://127.0.0.1:8001', ua_timeout => 5);
# my $k = KongApi->new(server => 'http://192.168.0.2:8001', ua_timeout => 5);


# print Dumper $k->api->new(name => 'mockbin', upstream_url => 'http://mockbin.com/', request_host => 'mockbin.com')->update;

my $tr = {data => [1,2,4]};

foreach my $i (0 .. @{$tr->{data}}-1) {
	print $i;
}

# foreach (@{$k->consumer->find}) {
#     print Dumper $_->delete;
# }

# print Dumper $k->plugin->findOne(id => '2ea2465b-744e-4a73-9918-98b687aafa78')->delete(on_error => sub {print Dumper shift->data});

# print Dumper $k->consumer->new(username => 'Alexander')->add;

# print "${\($k->api->type)}";

# print Dumper $k->plugin->findOne(id => '0a00ba00-5b56-46bc-9828-f3fb77fd1100', on_error => sub {say shift->message})->update();

# print Dumper $k->plugin->findOne(id => '15cc2ad1-4c85-43ef-ae0d-bf0d23fd5422', on_error => sub {say shift->message})->config({hide_credentials => 'false'})->add_update();


# print Dumper $k->plugin->new(
#     name => 'basic-auth',
#     api_name => 'mockbin',
#     api_id => 'ac4f957c-72f2-4ee7-82d9-e30d7ca43bf4',
# )->add;


# print Dumper $k->plugin->findOne(id => 'd38d95be-f246-4e57-b243-6fef335fb6ef')->delete(on_success => sub {say 'went ok!'});

# my $found = $k->api->findOne(id => 'edfcaee2-954b-4403-bda6-308fe99fbfc8', on_error => sub {say 'code: '.shift->code});
# if ($found) {
# 	$found->delete(on_success => sub {say 'ok'});
# }
