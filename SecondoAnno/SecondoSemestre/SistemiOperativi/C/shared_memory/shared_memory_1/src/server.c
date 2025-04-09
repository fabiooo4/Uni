#include <stdio.h>
#include <stdlib.h>
#include <sys/sem.h>
#include <sys/shm.h>

#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include "../inc/errExit.h"
#include "../inc/semaphore.h"
#include "../inc/shared_memory.h"

#define BUFFER_SZ 100

#define REQUEST 0
#define DATA_READY 1

int create_sem_set(key_t semkey) {
  // Create a semaphore set with 2 semaphores
  int semid = semget(semkey, 2, S_IRUSR | S_IWUSR | IPC_CREAT);
  if (semid == -1)
    errExit("semget failed");

  // Initialize the semaphore set with semctl
  union semun arg;
  unsigned short values[] = {0, 0};
  arg.array = values;

  semctl(semid, 0, SETALL, arg);
  return semid;
}

void copy_file(const char *pathname, char *buffer) {
  // open in read only mode the file
  int file = open(pathname, O_RDONLY);
  if (file == -1) {
    printf("File %s does not exist\n", pathname);
    buffer[0] = -1;
    return;
  }

  // read a chunks of BUFFER_SZ - 1 characters
  ssize_t bR = read(file, buffer, BUFFER_SZ - 1);
  if (bR > 0)
    buffer[bR] = '\0'; // end the line with '\0'
  else
    printf("read failed\n");

  // close the file descriptor
  close(file);
}

int main(int argc, char *argv[]) {

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
  int shmidServer = alloc_shared_memory(shmKey, sizeof(struct Request));

  // attach the shared memory segment
  printf("<Server> attaching the shared memory segment...\n");
  struct Request *request = get_shared_memory(shmidServer, SHM_RDONLY);

  // create a semaphore set
  printf("<Server> creating a semaphore set...\n");
  int semid = create_sem_set(semkey);

  // wait for a Request (REQUEST)
  printf("<Server> waiting for a request...\n");
  semOp(semid, REQUEST, -1);

  // allocate a shared memory segment
  printf("<Server> getting the client's shared memory segment...\n");
  int shmidClient = alloc_shared_memory(request->shmKey, BUFFER_SZ);

  // attach the shared memory segment
  printf("<Server> attaching the client's shared memory segment...\n");
  char *buffer = (char *)get_shared_memory(shmidClient, 0);

  // copy file into the shared memory
  printf("<Server> coping a file into the client's shared memory...\n");
  copy_file(request->pathname, buffer);

  // notify that data was stored into the client's shared memory
  printf("<Server> notifing data is ready...\n");
  semOp(semid, DATA_READY, 1);

  // detach the shared memory segment
  printf("<Client> detaching the client's shared memory segment...\n");
  free_shared_memory(buffer);

  // detach the shared memory segment
  printf("<Server> detaching the shared memory segment...\n");
  free_shared_memory(request);

  // remove the shared memory segment
  printf("<Server> removing the shared memory segment...\n");
  remove_shared_memory(shmidServer);

  return 0;
}
