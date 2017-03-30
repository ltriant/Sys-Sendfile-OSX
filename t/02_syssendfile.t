#!/usr/bin/env perl

use warnings;
use strict;

use Test::Most tests => 5;
use IO::Socket;
use Fcntl qw(SEEK_SET);

require_ok('Sys::Sendfile::OSX');
use_ok('Sys::Sendfile::OSX');
can_ok('Sys::Sendfile::OSX', 'syssendfile');

open my $in_h, '<', $0 or die "open(): $!";

my $count = 10;

my $slurped;
sysread($in_h, $slurped, $count);
seek($in_h, 0, SEEK_SET);

my $listen = IO::Socket::INET->new(Listen => 1)
	or die "listen(): $!";

my $in = IO::Socket::INET->new(
	PeerHost => $listen->sockhost,
	PeerPort => $listen->sockport
) or die "connect(): $!";

my $out_h = $listen->accept;

my $total_sent = Sys::Sendfile::OSX::syssendfile(fileno($in_h), $out_h->fileno, $count, 0);
is($total_sent, $count, "sent $count bytes of \$0 from offset 0 into socket");

$in->recv(my $buf, $count);
is($buf, $slurped, "recv'd the same data that we sent");

$in->close;
$out_h->close;

# TODO test non-blocking filehandles and sockets
