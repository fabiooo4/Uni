#ifndef _REQUEST_RESPONSE_HH
#define _REQUEST_RESPONSE_HH

#include <sys/types.h>

struct Request {   /* Request (client --> server) */
    pid_t cPid;    /* PID of client               */
    int code;      /* a random number             */
};

struct Response {  /* Response (server --> client) */
    int result;    /* Request.code ^ 2             */
};

#endif
