#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include "producer.h"
#include "errExit.h"

#define MSG_BYTES 100

struct Item {
    ssize_t size;
    char value [MSG_BYTES];
};

void producer (int *pipeFD, const char *filename) {
    // Close the read-end of the pipe
    // ...

    printf("<Producer> text file: %s\n", filename);

    // Open the text file in read only mode
    int file = // ...

    struct Item item;
    do {
        // read a chunk of bytes from file:
        // copy in item.value a chunk of bytes from the file, and
        // set item.size equal to the number of read bytes
        // ...
        if (item.size == -1)
            errExit("read failed");

        if (item.size > 0) {
            // What is the right size?
            // (size of a ssize_t and the number of read chars)
            ssize_t bytes2send = // ...
            // send struct item to Consumer through pipe
            ssize_t bW = write(pipeFD[1], &item, bytes2send);
            // check bW value
            // ...
        }
    } while (item.size > 0);

    // Close the write end of the pipe
    // ...

    return;
}
