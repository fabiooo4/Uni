#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include "consumer.h"
#include "errExit.h"

#define MSG_BYTES 100

void consumer (int *pipeFD) {
    // close pipe's write end
    // ...

    ssize_t rB = -1;
    char buffer[MSG_BYTES + 1];
    do {
        // first we read the 'size' field of an Item
        ssize_t size;
        rB = // ...
        if (/*...*/)
            printf("<Consumer> it looks like the pipe is broken\n");
        else if (/*...*/)
            printf("<Consumer> it looks like all pipe's write ends were closed\n");
        else if (/*...*/)
            printf("<Consumer> it looks like there is not ssize_t\n");
        else {
            // then, we read the 'value' field of an Item
            rB = //...
            if (/*...*/)
                printf("<Consumer> it looks like the pipe is broken\n");
            else if (/*...*/)
                printf("<Consumer> it looks like all pipe's write ends were closed\n");
            else if (/*...*/)
                printf("<Consumer> it looks like there is no value \n");
            else {
                buffer[size] = '\0';
                printf("<Consumer> line: %s\n", buffer);
            }
        }
    } while (rB > 0);

    // close pipe's read end
    // ...
}
