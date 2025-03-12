#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#include <sys/stat.h>
#include <sys/sem.h>
#include <sys/shm.h>

#include "shared_memory.h"
#include "semaphore.h"
#include "errExit.h"

#define BUFFER_SZ 100

#define REQUEST      0
#define DATA_READY   1
#define CLIENT_READY 2

int main (int argc, char *argv[]) {

    // check command line input arguments
    if (argc != 4) {
        printf("Usage: %s server_shared_memory_key semaphore_key client_shared_memory_key\n", argv[0]);
        exit(1);
    }

    // read the server's shared memory key
    key_t shmKeyServer = atoi(argv[1]);
    if (shmKeyServer <= 0) {
        printf("The server_shared_memory_key must be greater than zero!\n");
        exit(1);
    }

    // read the semaphore key defined by user
    key_t semkey = atoi(argv[2]);
    if (semkey <= 0) {
        printf("The semaphore_key must be greater than zero!\n");
        exit(1);
    }

    // read the semaphore key defined by user
    key_t shmKeyClient = atoi(argv[3]);
    if (shmKeyClient <= 0) {
        printf("The client_shared_memory_key must be greater than zero!\n");
        exit(1);
    }

    // get the server's shared memory segment
    printf("<Client> getting the server's shared memory segment...\n");
    int shmidServer = // ...

    // attach the shared memory segment
    printf("<Client> attaching the server's shared memory segment...\n");
    struct Request *request = // ...

    // read a pathname from user
    printf("<Client> Insert pathname: ");
    scanf("%s", request->pathname);

    // allocate a shared memory segment
    printf("<Client> allocating a shared memory segment...\n");
    int shmidClient = // ...

    // attach the shared memory segment
    printf("<Client> attaching the shared memory segment...\n");
    char *buffer = // ...

    // copy shmKeyClient into the server's shared memory segment
    request->shmKey = shmKeyClient;

    // get the server's semaphore set
    int semid = // ...
    if (semid > 0) {
        // unlock the server (REQUEST)
        // ...

        int cond = 0;
        printf("<Client> reading data from the shared memory segment...\n");
        do {
            // wait for data (DATA_READY)
            // ...

            // check server's response
            cond = (buffer[0] != 0 && buffer[0] != -1);
            // print data on terminal
            if (cond)
                printf("%s", buffer);

            // notify the server that data was acquired (CLIENT_READY)
            // ...
        } while (cond);
    } else
        printf("semget failed");

    // detach the shared memory segment
    printf("<Client> detaching the server's shared memory segment...\n");
    // ...

    // detach the server's shared memory segment
    printf("<Client> detaching the server's shared memory segment...\n");
    // ...

    // remove the shared memory segment
    printf("<Client> removing the shared memory segment...\n");
    // ...

    // remove the created semaphore set
    printf("<Client> removing the semaphore set...\n");
    // ...

    return 0;
}
