# NAME

Sys::Sendfile::OSX - Exposing sendfile() for OS X

# SYNOPSIS

    use Sys::Sendfile::OSX qw(sendfile);

    open my $local_fh, '<', 'somefile';
    my $socket_fh = IO::Socket::INET->new(
      PeerHost => "10.0.0.1",
      PeerPort => "8080"
    );

    my $rv = sendfile($local_fh, $socket_fh);

# DESCRIPTION

The sendfile() function is a zero-copy function for transferring the
contents of a filehandle to a streaming socket.

As per the man pages, the sendfile() function was made available as of Mac
OS X 10.5.

# Sys::Sendfile

Why would you use this module over [Sys::Sendfile](https://metacpan.org/pod/Sys::Sendfile)? The answer is: you
wouldn't.

I wrote this module because I forgot [Sys::Sendfile](https://metacpan.org/pod/Sys::Sendfile) existed. As such, I
never released this to CPAN.

Use [Sys::Sendfile](https://metacpan.org/pod/Sys::Sendfile).

# EXPORTED FUNCTIONS

- sendfile($from, $to\[, $count\])

    Pipes the contents of the filehandle `$from` into the socket stream `$to`.

    Optionally, it will make multiple sendfile() calls to do it, piping across
    `$count` bytes at a time. Otherwise it will attempt to send the entire
    contents of the filehandle in one call.

    The filehandles can be globs or they can be [IO::Handle](https://metacpan.org/pod/IO::Handle)-like objects
    (or anything that has a `fileno` method).

- syssendfile($from, $to, $count, $offset)

    A direct one-to-one call into the sendfile() syscall. See the man pages for
    usage information.

# REPOSITORY

[https://github.com/ltriant/Sys-Sendfile-OSX](https://github.com/ltriant/Sys-Sendfile-OSX)

# AUTHOR

Luke Triantafyllidis <ltriant@cpan.org>

# SEE ALSO

[Sys::Sendfile](https://metacpan.org/pod/Sys::Sendfile), sendfile(2)

# LICENSE

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
