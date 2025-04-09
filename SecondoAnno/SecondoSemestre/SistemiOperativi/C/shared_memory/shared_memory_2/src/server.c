#include <stdio.h>
#include <stdlib.h>
#include <sys/shm.h>
#include <sys/sem.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

#include "shared_memory.h"
#include "semaphore.h"
#include "errExit.h"

#define BUFFER_SZ    100

#define REQUEST      0
#define DATA_READY   1
#define CLIENT_READY 2

int create_sem_set(key_t semkey) {
    // Create a semaphore set with 2 semaphores
    int semid = // ...
    if (semid == -1)
        errExit("semget failed");

    // Initialize the semaphore set
    union semun arg;
    unsigned short values[] = {0, 0, 0};
    arg.array = values;

    // ...
    return semid;
}

void copy_file(const char *pathname, char *buffer, int semid) {
    // open in read only mode the file
    int file = open(pathname, O_RDONLY);
    if (file == -1) {
        printf("File %s does not exist\n", pathname);
        buffer[0] = -1;
        return;
    }

    ssize_t bR = 0;
    do {
        // read the file in chunks of BUFFER_SZ - 1 characters
        bR = read(file, buffer, BUFFER_SZ - 1);
        if (bR >= 0) {
            buffer[bR] = '\0'; // end the lie with '\0'
            // notify that data was stored into client's shared memory (DATA_READY)
            // ...
            // wait for ack from client (CLIENT_READY)
            // ...
        } else
            printf("read failed\n");
    } while (bR > 0);

    // close the file descriptor
    close(file);
}

int main (int argc, char *argv[]) {

    // check command line input arguments
    if (argc != 3) {
        printf("Usage: %s shared_memory_key semaphore_key\n", argv[0]);
        exit(1);
    }

    // read the shared memory key defined by user
    key_t shmKey = atoi(argv[1]);
    if (shmKey <= 0) {
        printf("The shared_memory_key must be greater than zero!\n");
        exit(1);
    }

    // read the semaphore set key defined by user
    key_t semkey = atoi(argv[2]);
    if (semkey <= 0) {
        printf("The semaphore_key must be greater than zero!\n");
        exit(1);
    }

    // allocate a shared memory segment
    printf("<Server> allocating a shared memory segment...\n");
    int shmidServer = // ...

    // attach the shared memory segment
    printf("<Server> attaching the shared memory segment...\n");
    struct Request *request = // ...

    // create a semaphore set
    printf("<Server> creating a semaphore set...\n");
    int semid = // ...

    // wait for a Request (REQUEST)
    printf("<Server> waiting for a request...\n");
    // ...

    // allocate a shared memory segment
    printf("<Server> getting the client's shared memory segment...\n");
    int shmidClient = // ...

    // attach the shared memory segment
    printf("<Server> attaching the client's shared memory segment...\n");
    char *buffer = // ...

    // copy file into the shared memory
    printf("<Server> coping a file into the client's shared memory...\n");
    copy_file(request->pathname, buffer, semid);

    // detach the shared memory segment
    printf("<Client> detaching the client's shared memory segment...\n");
    // ...

    // detach the shared memory segment
    printf("<Server> detaching the shared memory segment...\n");
    // ...

    // remove the shared memory segment
    printf("<Server> removing the shared memory segment...\n");
    // ...

    return 0;
}
