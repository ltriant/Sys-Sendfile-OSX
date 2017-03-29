package Sys::Sendfile::OSX;

# ABSTRACT: Exposing sendfile() for OS X

use strict;
use warnings;

use Exporter;
our @EXPORT_OK = qw(sendfile);

require XSLoader;
XSLoader::load('Sys::Sendfile::OSX');

sub _get_fileno {
	my ($fh) = @_;

	if (ref $fh eq 'GLOB') {
		return fileno($fh);
	}

	# Should handle most IO::Handle-like objects
	if ($fh->can('fileno')) {
		return $fh->fileno;
	}

	return ();
}

sub sendfile {
	my ($in, $out, $count) = @_;

	my $in_h  = _get_fileno($in);
	my $out_h = _get_fileno($out);

	$count ||= 0;

	return Sys::Sendfile::OSX::handle::sendfile(
		$in_h,
		$out_h,
		$count,
	);
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

 my $rv = sendfile($local_fh, $socket_fh);

=head1 DESCRIPTION

The sendfile() function is a zero-copy function for transferring the
contents of a filehandle to a streaming socket.

As per the man pages, the sendfile() function was made available as of Mac
OS X 10.5.

=head1 FUNCTIONS

=over

=item sendfile($from, $to[, $count])

Pipes the contents of the filehandle C<$from> into the socket stream C<$to>.

Optionally, it will make multiple sendfile() calls to do it, piping across
C<$count> bytes at a time. Otherwise it will attempt to send the entire
contents of the filehandle in one call.

The filehandles can be globs or they can be L<IO::Handle>-like objects
(or anything that has a C<fileno> method).

=back

=head1 AUTHOR

Luke Triantafyllidis <ltriant@cpan.org>

=head1 SEE ALSO

L<Sys::Sendfile>, sendfile(2)
