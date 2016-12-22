package KongApi::Functions;
use strict;
use warnings;
use Exporter 'import';

use Mojo::UserAgent;

our @EXPORT_OK = qw(get post delete);

my $ua = Mojo::UserAgent->new();

sub get {
	my %args = @_;
	return $ua->get($args{url})->res;
}

sub post {
	
}

sub delete {
	
}


1;