#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define MAX_THREADS 10
#define MAX_SEQUENCE 100

// Structure for thread information
typedef struct {
    int start;
    int end;
    unsigned long long *result;  // Shared array for the calculated Fibonacci sequence
    pthread_mutex_t *mutex;      // Mutex for synchronization
    int thread_num;              // Thread number
} ThreadInfo;

// Function to calculate the #n Fibonacci number
unsigned long long fibonacci(int n) {
    if (n <= 1) {
        return n;
    } else {
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
}

// Function executed by each thread
void *calculateFibonacci(void *arg) {
    // Cast the argument to the ThreadInfo structure
    ThreadInfo *info = (ThreadInfo *)arg;

    // Calculate Fibonacci numbers for the assigned range
    for (int i = info->start; i <= info->end; i++) {
        unsigned long long fib = fibonacci(i);

        // Lock the mutex before updating the shared result array
        /* ... */
        
        info->result[i] = fib;

        // Print the calculation information
        printf("Thread %d calculated Fibonacci(%d) = %llu\n", info->thread_num, i, fib);

        // Unlock the mutex after updating the shared result array
        /* ... */
    }

    // Exit the thread
    /* ... */
}

int main() {
    int numThreads, sequenceLength;

    // Get user input for the number of threads and sequence length
    printf("Enter the number of threads (1-%d): ", MAX_THREADS);
    scanf("%d", &numThreads);

    if (numThreads < 1 || numThreads > MAX_THREADS) {
        printf("Invalid number of threads. Exiting.\n");
        return 1;
    }

    printf("Enter the length of the Fibonacci sequence (1-%d): ", MAX_SEQUENCE);
    scanf("%d", &sequenceLength);

    if (sequenceLength < 1 || sequenceLength > MAX_SEQUENCE) {
        printf("Invalid sequence length. Exiting.\n");
        return 1;
    }

    // Allocate memory for the result array and mutex
    unsigned long long *result = (unsigned long long *)malloc(sequenceLength * sizeof(unsigned long long));
    // Create mutex and initialize it
    /* ... */
    /* ... */

    // Create threads and thread information
    /* ... */
    ThreadInfo threadInfo[MAX_THREADS];

    // Calculate the range of Fibonacci numbers for each thread
    int elementsPerThread = sequenceLength / numThreads;
    int remainingElements = sequenceLength % numThreads;
    int start = 0;

    // Create threads and assign tasks
    for (int i = 0; i < numThreads; i++) {
        // Set the start and end indices for each thread's range
        threadInfo[i].start = start;
        threadInfo[i].end = start + elementsPerThread - 1 + (i < remainingElements ? 1 : 0);
        start = threadInfo[i].end + 1;

        // Share the main result array, mutex, and thread number
        threadInfo[i].result = result;
        threadInfo[i].mutex = &mutex;
        threadInfo[i].thread_num = i + 1;

        // Create threads
        /* ... */
    }

    // Wait for threads to finish
    for (int i = 0; i < numThreads; i++) {
        /* ... */
    }

    // Print the Fibonacci sequence
    printf("\nFibonacci sequence:\n");
    for (int i = 0; i < sequenceLength; i++) {
        printf("%llu ", result[i]);
    }
    printf("\n");

    // Free the memory for the result
    free(result);
    // Destroy the mutex
    /* ... */

    return 0;
}
