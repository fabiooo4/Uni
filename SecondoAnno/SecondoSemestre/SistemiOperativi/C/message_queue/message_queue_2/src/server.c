#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <sys/stat.h>
#include <sys/msg.h>
#include <unistd.h>

#include "order.h"
#include "errExit.h"

// the message queue identifier
int msqid = -1;

void signTermHandler(int sig) {
    // do we have a valid message queue identifier?
    if (msqid > 0) {
        //...
    }

    // terminate the server process
    exit(0);
}

int main (int argc, char *argv[]) {
    // check command line input arguments
    if (argc != 2) {
        printf("Usage: %s message_queue_key\n", argv[0]);
        exit(1);
    }

    // read the message queue key defined by user
    int msgKey = atoi(argv[1]);
    if (msgKey <= 0) {
        printf("The message queue key must be greater than zero!\n");
        exit(1);
    }

    // set the function sigHandler as handler for the signals SIGINT, SIGTERM and SIGHUP
    // ...

    printf("<Server> Making MSG queue...\n");
    // get the message queue, or create a new one if it does not exist
    msqid = // ...

    // check functionality
    printf("<Server> sleep...\n");
    sleep(60);
    // the process sleeps for 1 minutes. Try to send some orders
    // and check that prime users' orders are always read before
    // normal users' ones

    struct order order;
    // endless loop
    while (1) {
	    // read a message from the message queue.
        // ...

        // print the order on standard output
        printOrder(&order);
    }

    return 0;
}
