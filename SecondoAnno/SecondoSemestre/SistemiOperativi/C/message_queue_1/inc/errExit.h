#ifndef _ERREXIT_HH
#define _ERREXIT_HH

/* errExit is a support function to print
 * the error message of the last failed system call.
 * errExit terminates the calling process as well.
 */
void errExit(const char *msg);

#endif
