#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#include <sys/stat.h>
#include <sys/msg.h>

#include "order.h"
#include "errExit.h"

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

    // get the message queue identifier
    int msqid = // ...

    char buffer[10];
    size_t len;

    // crea an order data struct
    struct order order;

    // setting the order's type
    printf("Are you a prime user[y/n]: ");
    order.mtype = // ...

    // read the code of the client's order
    printf("Insert order code: ");
    // ...

    // read a description of the order
    printf("Insert a description: ");
    // ...

    // read a quantity
    printf("Insert quantity: ");
    // ...

    // read an e-mail
    printf("Insert an e-mail: ");
    // ...

    // send the order to the server through the message queue
    printf("Sending the order...\n");
    // ...

    printf("Done\n");
    return 0;
}
