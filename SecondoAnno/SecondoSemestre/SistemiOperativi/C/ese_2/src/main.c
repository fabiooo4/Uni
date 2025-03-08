#include <stdio.h>
#include <stdlib.h>
#include <sys/ipc.h>
#include <unistd.h>

#include <sys/sem.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "../inc/errExit.h"
#include "../inc/semaphore.h"

// function to print the semaphore set's state
void printSemaphoresValue(int semid) {
  unsigned short semVal[4];
  union semun arg;
  arg.array = semVal;

  // get the current state of the set
  if (semctl(semid, 0 /*ignored*/, GETALL, arg) == -1)
    errExit("semctl GETALL failed");

  // print the semaphore's value
  printf("\nsemaphore set state:\n");
  for (int i = 0; i < 4; i++)
    printf("id: %d --> %d\n", i, semVal[i]);
}

int main(int argc, char *argv[]) {

  char *messages[] = {"C", "B", "A"};

  // Create a semaphore set with 4 semaphores
  int semid = semget(IPC_PRIVATE, 4, S_IRUSR | S_IWUSR);
  if (semid == -1)
    errExit("semget failed");

  // Initialize the semaphore set with semctl
  unsigned short semInitVal[] = {0, 0, 1, 3};
  union semun arg;
  arg.array = semInitVal;

  if (semctl(semid, 0, SETALL, arg) == -1)
    errExit("semctl SETALL failed");

  printSemaphoresValue(semid);

  // Generate 3 child processes:
  // child-0 prints message[0], ... child-3 prints message[3]
  for (int child = 0; child < 3; ++child) {
    pid_t pid = fork();
    // check error for fork
    if (pid < 0)
      printf("child %d not created!", child);
    // check if running process is child or parent
    else if (pid == 0) {
      // code executed only by the child

      // wait for all the processes completion
      semOp(semid, (unsigned short)3, -1);

      // wait for the i-th semaphore
      semOp(semid, (unsigned short)child, -1);

      write(1, messages[child], 1);

      if (child != 0) 
        // unlock the previous child
        semOp(semid, (unsigned short)child - 1, 1);
      else
        // the last child unlocks all the completions stage
        semOp(semid, (unsigned short)3, 3);


      // wait for the last process to finish
      semOp(semid, (unsigned short)3, -1);

      write(1, " Done ", 6);

      exit(0);
    }
  }
  // code executed only by the parent process

  // wait for the termination of all child processes
  wait(NULL);

  printSemaphoresValue(semid);

  // remove the created semaphore set
  if (semctl(semid, 0, IPC_RMID) == -1)
    errExit("semctl IPC_RMID failed");

  return 0;
}
