#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

#include "errExit.h"

int main (int argc, char *argv[]) {

    // Check command line input arguments.
    // The program only wants a text file
    if (argc != 2) {
        printf("Usage: %s times\n", argv[0]);
        return 0;
    }

    int times = atoi(argv[1]);
    if (times == 0)
        return 0;

    // a pipe is a unirectional bytes stream. If two process have to exchange
    // data through pipe, then two pipes are needed.

    // the first pipe lets the parent process send data to the child process
    int pipe_parent2child[2];
    // the second pipe lets the child process send data to the parent process
    int pipe_child2parent[2];

    // Make new PIPEs
    // ...

    ssize_t rB, wB = -1;
    char buffer [5];

    switch (fork()) {
        case -1:
            errExit("fork failed");
        case 0: {
            // close the write end of the pipe parent2child,
            // and the read end of the pipe child2parent
            // ...

            char *pongText = "pong";
            ssize_t textSize = strlen(pongText) + 1;
            for (int i = 0; i < times; i++) {
                // read 'ping' from the parent process
                // ...

                printf("%d - %s\n", (i + 1), buffer);

                // write 'pong' to the parent process
                // ...
            }

            // close the read end of the pipe parent2child,
            // and the write end of the pipe child2parent
            // ...

            _exit(0);
        }
        default: {
            // close the read end of the pipe parent2child,
            // and the write end of the pipe child2parent
            // ...

            char *pingText = "ping";
            ssize_t textSize = strlen(pingText) + 1;
            for (int i = 0; i < times; i++) {
                // write 'ping' to the child process
                // ...

                // read 'pong' from the parent process
                // ...

                printf("%d - %s\n", (i + 1), buffer);
            }

            // close the write end of the pipe parent2child,
            // and the read end of the pipe child2parent
            // ...
        }
    }
    
    return 0;
}
