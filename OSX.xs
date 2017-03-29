#include <sys/types.h>
#include <sys/socket.h>
#include <sys/uio.h>

#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = Sys::Sendfile::OSX    PACKAGE = Sys::Sendfile::OSX::handle

SV *
sendfile(in, out, count = 0)
		int    in;
		int    out;
		size_t count;
	CODE:
		off_t bytes = count;
		off_t total = 0;

		while (1) {
			int ret = sendfile(in, out, total, &bytes, NULL, 0);

			if ((ret == -1) && (bytes == 0) && (errno != EINTR) && (errno != EAGAIN))
				XSRETURN_EMPTY;

			if (bytes == 0) {
				// eof
				break;
			}

			total += bytes;
		}

		XSRETURN_IV(total);
