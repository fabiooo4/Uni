#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define MAX_THREADS 10

// Structure for thread information
typedef struct {
    int start;
    int end;
    unsigned long long result;
} ThreadInfo;

// Function to calculate the factorial of a given range
void *calculateFactorial(void *arg) {
    ThreadInfo *info = (ThreadInfo *)arg;
    unsigned long long factorial = 1;

    // Calculate factorial for the assigned range
    /* ... */

    // Store the result in the thread info
    info->result = factorial;

    // Exit the thread
    /* ... */
}

int main() {
    int numThreads, number;
    unsigned long long totalFactorial = 1;

    // Get input from the user
    printf("Enter the number of threads (1-%d): ", MAX_THREADS);
    scanf("%d", &numThreads);

    if (numThreads < 1 || numThreads > MAX_THREADS) {
        printf("Invalid number of threads. Exiting.\n");
        return 1;
    }

    printf("Enter the number to calculate factorial: ");
    scanf("%d", &number);

    // Create threads and thread information
    /* ... */
    ThreadInfo threadInfo[MAX_THREADS];

    // Calculate the range for each thread
    int elementsPerThread = number / numThreads;
    int remainingElements = number % numThreads;
    int start = 1;

    // Create threads and assign tasks
    for (int i = 0; i < numThreads; i++) {
        // Set the start and end values for the range
        threadInfo[i].start = start;
        threadInfo[i].end = start + elementsPerThread - 1 + (i < remainingElements ? 1 : 0);
        start = threadInfo[i].end + 1;

        // Create threads
        /* ... */
    }

    // Wait for threads to finish and calculate total factorial
    for (int i = 0; i < numThreads; i++) {
        /* ... */
    }

    // Print the total factorial
    printf("Factorial of %d is: %llu\n", number, totalFactorial);

    return 0;
}

