#include <sys/sem.h>

#include "semaphore.h"
#include "errExit.h"

void semOp (int semid, unsigned short sem_num, short sem_op) {
    struct sembuf sop = { /*...*/};

    if (semop(/*...*/) == /*...*/)
        errExit("semop failed");
}
