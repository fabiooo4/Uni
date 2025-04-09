#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

#include "consumer.h"
#include "producer.h"
#include "errExit.h"

int main (int argc, char *argv[]) {

    // Check command line input arguments.
    if (argc == 1) {
        printf("Usage: %s textFile1 ... textFileN\n", argv[0]);
        return 0;
    }

    int pipeFD[2];

    // Make a new PIPE
    // ...

    // Generate a sub process reading a text file token-by-token
    printf("<Consumer> making %d subprocesses...\n", (argc - 1));
    for (int i = 0; i < (argc - 1); ++i) {
        pid_t pid = fork();
        if (pid == -1)
            printf("Fork failed. The file %s will not be read!\n", argv[1 + i]);
        else if (pid == 0) {
            producer(pipeFD, argv[1 + i]);
            _exit(0);
        }
    }

    // run the consumer process, which reads the pipe
    consumer(pipeFD);

    // wait the termination of all child process.
    while (wait(NULL) != -1);

}
