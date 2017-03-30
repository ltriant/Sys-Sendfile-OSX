#!/usr/bin/env perl

use warnings;
use strict;

use Test::Most tests => 5;
use IO::Socket;
use Fcntl qw(SEEK_SET);

require_ok('Sys::Sendfile::OSX');
use_ok('Sys::Sendfile::OSX');
can_ok('Sys::Sendfile::OSX', 'sendfile');

open my $in_h, '<', $0 or die "open(): $!";

my $slurped = do { local $/; <$in_h> };
seek($in_h, 0, SEEK_SET);

my $listen = IO::Socket::INET->new(Listen => 1)
	or die "listen(): $!";

my $in = IO::Socket::INET->new(
	PeerHost => $listen->sockhost,
	PeerPort => $listen->sockport
) or die "connect(): $!";

my $out_h = $listen->accept;

my $count = 10;
my $total_sent = Sys::Sendfile::OSX::sendfile($in_h, $out_h, $count);
is($total_sent, -s $in_h, "sent all of \$0 into socket, $count bytes at a time");

$in->recv(my $buf, -s $in_h);
is($buf, $slurped, "recv'd the same data that we sent");

# TODO test non-blocking filehandles and sockets
