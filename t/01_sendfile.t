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
my $total_sent = Sys::Sendfile::OSX::sendfile($in_h, $out_h, $count);

is($total_sent, -s $in_h, "slurped all of \$0 into socket, $count bytes at a time");

# TODO test non-blocking filehandles and sockets

done_testing();
