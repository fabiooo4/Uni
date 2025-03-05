#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include <sys/wait.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/sem.h>

#include "semaphore.h"
#include "errExit.h"

// function to print the semaphore set's state
void printSemaphoresValue (int semid) {
    unsigned short semVal[4];
    union semun arg;
    arg.array = semVal;

    // get the current state of the set
    if (semctl(semid, 0 /*ignored*/, GETALL, arg) == -1)
        errExit("semctl GETALL failed");

    // print the semaphore's value
    printf("semaphore set state:\n");
    for (int i = 0; i < 4; i++)
        printf("id: %d --> %d\n", i, semVal[i]);
}

int main (int argc, char *argv[]) {

    char *messages[] = {"C", "B", "A"};

    // Create a semaphore set with 4 semaphores
    int semid = //...
    if (semid == -1)
        errExit("semget failed");

    // Initialize the semaphore set with semctl
    unsigned short semInitVal[] = {0, 0, 1, 3};
    union semun arg;
    arg.array = semInitVal;

    if (/*...*/)
        errExit("semctl SETALL failed");

    printSemaphoresValue(semid);

    // Generate 3 child processes:
    // child-0 prints message[0], ... child-3 prints message[3]
    for (int child = 0; child < 3; ++child) {
        pid_t pid = fork();
        // check error for fork
        if (/*...*/)
            printf("child %d not created!", child);
        // check if running process is child or parent
        else if (/*...*/) {
            // code executed only by the child

            // ... 

            exit(0);
        }
    }
    // code executed only by the parent process

    // wait for the termination of all child processes
    //...

    printSemaphoresValue(semid);

    // remove the created semaphore set
    if (/*...*/)
        errExit("semctl IPC_RMID failed");

    return 0;
}
