#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "errExit.h"

#define NUM_THREADS 3

// Initialize the mutex, a primary condition and a done condition
/* ... */
/* ... */
/* ... */
int current_thread = 2;
int done_count = 0;

char *messages[] = {"C", "B", "A"};

void *thread_function(void *arg) {
    // Extract the integer argument value
    int thread_num = *((int *) arg);

    // Lock the mutex
    /* ... */

    while (current_thread != thread_num) {
        // Wait for the condition
        /* ... */
    }

    // Print the message
    printf("%s\n", messages[thread_num]);
    // Force immediate printing on stdout
    fflush(stdout);

    // Signal the next thread to print
    current_thread = (current_thread - 1) % NUM_THREADS;
    /* ... */

    // Wait until all threads have printed their first message
    done_count++;
    if (done_count < NUM_THREADS) {
        /* ... */
    } else {
        // Signal all threads to print "done"
        /* ... */
    }

    // Print "done"
    printf("done\n");
    // Force immediate printing on stdout
    fflush(stdout);

    // Unlock the mutex
    /* ... */

    return NULL;
}

int main() {
    // Pthreads array
    /* ... */
    // Parameters array
    int *thread_ids[NUM_THREADS];

    // Create threads
    for (int i = 0; i < NUM_THREADS; ++i) {
        thread_ids[i] = malloc(sizeof(int)); // Allocate memory for thread ID
        if (thread_ids[i] == NULL) {
            errExit("malloc");
        }
        *thread_ids[i] = i; // Assign thread ID

        if (/* ... */) {
            errExit("pthread_create");
        }
    }

    // Wait for all threads to finish
    for (int i = 0; i < NUM_THREADS; ++i) {
        if (/* ... */) {
            errExit("pthread_join");
        }
    }

    // Free dynamically allocated memory for the function parameters
    for (int i = 0; i < NUM_THREADS; ++i) {
        free(thread_ids[i]);
    }

    return 0;
}
