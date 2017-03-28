#!/usr/bin/env perl

use warnings;
use strict;

use Test::Most;
use IO::Socket;

require_ok('Sys::Sendfile::OSX');
use_ok('Sys::Sendfile::OSX');
can_ok('Sys::Sendfile::OSX', 'sendfile');

open my $in_h, '<', $0 or die "open(): $!";

my $listen = IO::Socket::INET->new(Listen => 1)
	or die "listen(): $!";

my $in = IO::Socket::INET->new(
	PeerHost => $listen->sockhost,
	PeerPort => $listen->sockport
) or die "connect(): $!";

my $out_h = $listen->accept;

my $count = 10;
my $offset = 0;

my $total_sent = 0;
while (1) {
	my $bytes = Sys::Sendfile::OSX::sendfile(
		fileno($in_h),
		$out_h->fileno,
		$count,
		$offset,
	);

	if ($bytes == 0) {
		# eof
		last;
	}

	$offset += $bytes;
	$total_sent += $bytes;
}

is($total_sent, -s $in_h, "slurped all of \$0 into socket, $count bytes at a time");

done_testing();
