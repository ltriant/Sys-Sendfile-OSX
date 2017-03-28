package Sys::Sendfile::OSX;

# ABSTRACT: Exposing sendfile() for OS X

use strict;
use warnings;

use Exporter;
our @EXPORT_OK = qw(sendfile);

require XSLoader;
XSLoader::load('Sys::Sendfile::OSX');

sub sendfile {
	my ($in, $out, $count, $offset) = @_;

	$count  ||= 0;
	$offset ||= 0;

	return Sys::Sendfile::OSX::handle::sendfile($in, $out, $count, $offset);
}

1;

=head1 NAME

Sys::Sendfile::OSX - Exposing sendfile() for OS X

=head1 SYNOPSIS

 use Sys::Sendfile::OSX qw(sendfile);

 open my $local_fh, '<', 'somefile';
 my $socket_fh = IO::Socket::INET->new(
   PeerHost => "10.0.0.1",
   PeerPort => "8080"
 );

 my $rv = sendfile( fileno($local_fh), $socket_fh->fileno );

=head1 DESCRIPTION

The sendfile() function is a zero-copy function for transferring the
contents of a filehandle to a streaming socket.

=head1 AUTHOR

Luke Triantafyllidis <ltriant@cpan.org>

=head1 SEE ALSO

L<Sys::Sendfile>, sendfile(2)
