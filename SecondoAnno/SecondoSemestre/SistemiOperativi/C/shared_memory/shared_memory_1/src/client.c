#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <sys/stat.h>

#include "../inc/errExit.h"
#include "../inc/semaphore.h"
#include "../inc/shared_memory.h"

#define BUFFER_SZ 100

// Semaphore names
#define REQUEST 0
#define DATA_READY 1

int main(int argc, char *argv[]) {

  // check command line input arguments
  if (argc != 4) {
    printf("Usage: %s server_shared_memory_key semaphore_key "
           "client_shared_memory_key\n",
           argv[0]);
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
  int shmidServer = alloc_shared_memory(shmKeyServer, sizeof(struct Request));

  // attach the shared memory segment
  printf("<Client> attaching the server's shared memory segment...\n");
  struct Request *request = (struct Request *)get_shared_memory(shmidServer, 0);

  // read a pathname from user
  printf("<Client> Insert pathname: ");
  scanf("%s", request->pathname);

  fflush(stdout);

  // allocate a shared memory segment
  printf("<Client> allocating a shared memory segment...\n");
  int shmidClient = alloc_shared_memory(shmKeyClient, sizeof(char) * BUFFER_SZ);

  // attach the shared memory segment
  printf("<Client> attaching the shared memory segment...\n");
  char *buffer = (char *)get_shared_memory(shmidClient, SHM_RDONLY);

  // copy shmKeyClient into the server's shared memory segment
  request->shmKey = shmKeyClient;

  // get the server's semaphore set
  printf("<Client> getting the server's semaphore set...\n");
  int semid = semget(semkey, 2, S_IRUSR | S_IWUSR);
  if (semid > 0) {
    // unlock the server
    semOp(semid, REQUEST, 1);
    // wait for data
    semOp(semid, DATA_READY, -1);

    printf("<Client> reading data from the shared memory segment...\n");
    if (buffer[0] == -1)
      printf("File %s does not exist\n", request->pathname);
    else
      printf("%s\n", buffer);
  } else
    printf("semget failed");

  // detach the shared memory segment
  printf("<Client> detaching the server's shared memory segment...\n");
  free_shared_memory(buffer);

  // detach the server's shared memory segment
  printf("<Client> detaching the server's shared memory segment...\n");
  free_shared_memory(request);

  // remove the shared memory segment
  printf("<Client> removing the shared memory segment...\n");
  remove_shared_memory(shmidClient);

  // remove the created semaphore set
  printf("<Client> removing the semaphore set...\n");
  if (semctl(semid, 0, IPC_RMID) == -1)
    errExit("semctl IPC_RMID failed");

  return 0;
}
