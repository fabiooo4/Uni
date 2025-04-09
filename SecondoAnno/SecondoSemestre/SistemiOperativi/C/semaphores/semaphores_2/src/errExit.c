#include "../inc/errExit.h"

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

void errExit(const char *msg) {
  perror(msg);
  exit(1);
}
