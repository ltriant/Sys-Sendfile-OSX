#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/uio.h>

MODULE = Sys::Sendfile::OSX    PACKAGE = Sys::Sendfile::OSX::handle

SV *
sendfile(in, out, count = 0, offset = 0)
	int in;
	int out;
	size_t count;
	int offset;
	CODE:
	{
		off_t bytes = count;
		int ret = sendfile(in, out, offset, &bytes, NULL, 0);

		if (ret == 0) {
			XSRETURN_IV(bytes);
		}
		else {
			XSRETURN_EMPTY;
		}
	}
