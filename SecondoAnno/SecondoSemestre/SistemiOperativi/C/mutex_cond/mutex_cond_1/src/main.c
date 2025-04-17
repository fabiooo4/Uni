#include "../inc/errExit.h"
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NUM_THREADS 4

// Static initialization of a mutex
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
// Static initialization of a condition variable
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

int current_thread = 3;
int num_times;

char *messages[] = {"Operativi\n", "Sistemi ", "di ", "Corso "};

void *thread_function(void *arg) {
  int thread_num = *((int *)arg);
  free(arg);

  for (int i = 0; i < num_times; ++i) {
    // Lock the mutex
    pthread_mutex_lock(&mutex);

    while (current_thread != thread_num) {
      // Wait for the condition
      pthread_cond_wait(&cond, &mutex);
    }

    // Print the message for this thread
    printf("%s", messages[thread_num]);
    // Flush stdout to ensure immediate printing
    fflush(stdout);

    // Set the current_thread variable properly to ensure
    // that the phrase will be printed in the correct order
    if (current_thread != 0)
      current_thread = (current_thread - 1);
    else
      current_thread = 3;

    // Signal all threads waiting on the condition variable
    pthread_cond_broadcast(&cond);

    // Unlock the mutex
    pthread_mutex_unlock(&mutex);
  }

  return NULL;
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf("Usage: %s <number_of_times>\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  num_times = atoi(argv[1]);

  // Create the thread variables
  pthread_t threads[NUM_THREADS];
  int *thread_ids[NUM_THREADS];

  for (int i = 0; i < NUM_THREADS; ++i) {
    thread_ids[i] = malloc(sizeof(int));
    *thread_ids[i] = i;

    // Create the threads
    if (pthread_create(&threads[i], NULL, thread_function, (void *) (size_t) thread_ids[i])) {
      errExit("pthread_create");
    }
  }

  for (int i = 0; i < NUM_THREADS; ++i) {
    // Join the threads
    if (pthread_join(threads[i], NULL)) {
      errExit("pthread_join");
    }
  }

  // Destroy the mutex and condition variable
  pthread_mutex_destroy(&mutex);
  pthread_cond_destroy(&cond);

  return 0;
}
