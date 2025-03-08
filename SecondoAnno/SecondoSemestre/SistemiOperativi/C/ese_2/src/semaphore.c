#include <sys/sem.h>

#include "../inc/errExit.h"
#include "../inc/semaphore.h"

void semOp(int semid, unsigned short sem_num, short sem_op) {
  struct sembuf sop = {.sem_num = sem_num, .sem_op = sem_op, .sem_flg = 0};

  if (semop(semid, &sop, 1) == -1)
    errExit("semop failed");
}
