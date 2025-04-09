#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#include "consumer.h"
#include "producer.h"
#include "errExit.h"

int main (int argc, char *argv[]) {

    // Check command line input arguments.
    // The program only wants a text file
    if (argc != 2) {
        printf("Usage: %s textFile\n", argv[0]);
        return 0;
    }

    int pipeFD[2];

    // Make a new PIPE
    // ...

    // Generate a sub process reading a text file token-by-token
    printf("<Consumer> making a subprocess\n");
    switch (fork()) {
        case -1:
            errExit("fork failed");
        case 0: {
            producer(pipeFD, argv[1]);
            _exit(0);
        }
        default: {
            consumer(pipeFD);
        }
    }

}
