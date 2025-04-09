#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include "producer.h"
#include "errExit.h"

#define MSG_BYTES 100

void producer (int *pipeFD, const char *filename) {
    // Close the read-end of the pipe
    // ...

    printf("<Producer> text file: %s\n", filename);

    // open filename for reading only
    int file = // ...

    char buffer[MSG_BYTES];
    ssize_t bR, bW = -1;
    do {
        // read max MSG_BYTES chars from the file
        bR = // ...

        if (bR > 0) {
            // write bR chars to the pipe
            // ...
        }
    } while (bR > 0);

    // Close the write end of the pipe
    // ...

    return;
}
