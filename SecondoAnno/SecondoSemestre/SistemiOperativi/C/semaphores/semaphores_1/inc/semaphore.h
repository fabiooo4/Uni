#ifndef _SEMAPHORE_HH
#define _SEMAPHORE_HH

// definition of the union semun
#include <sys/sem.h>
union semun {
  int val;
  struct semid_ds *buf;
  unsigned short *array;
};

/* errsemOpExit is a support function to manipulate a semaphore's value
 * of a semaphore set. semid is a semaphore set identifier, sem_num is the
 * index of a semaphore in the set, sem_op is the operation performed on sem_num
 */
void semOp(int semid, unsigned short sem_num, short sem_op);

#endif
