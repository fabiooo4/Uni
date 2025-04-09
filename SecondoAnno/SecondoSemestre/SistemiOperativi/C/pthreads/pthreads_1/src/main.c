#include "../inc/errExit.h"
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

// Constant for predetermine the array size of integer numbers
#define ARRAY_SIZE 10
// Constant for predetermine the maximum number of threads that
// could be used for calculate the partial sums
#define MAX_THREADS ARRAY_SIZE

// Structure for shared data among threads
struct ThreadData {
  // start index for computing the partial sum
  int start;
  // end index for computing the partial sum
  int end;
  // partialSum computed by each thread
  long long partialSum;
  // Pointer to the shared array through each thread
  int *array;
};

// Function executed by each thread for calculate the partial sum
// Note that each thread receive a reference to the ThreadData
// struct. The variables present inside the ThreadData struct
// vary based on the thread number; the last element of the struct
// is passed to the procedure calculateSum as pointer.
// The function receive a (void *arg) argument that allows to pass
// more than one value.
void *calculateSum(void *arg) {
  struct ThreadData *threadData = (struct ThreadData *)arg;
  // Initialize the partialSum to zero.
  threadData->partialSum = 0;

  // Calculate sum for the assigned range
  for (int i = threadData->start; i <= threadData->end; i++) {
    threadData->partialSum += threadData->array[i];
  }

  return NULL;
}

// Program that compute the total sum of each elements of an array
// in parallel by using the Posix Threads (Pthreads).
int main() {
  // array to store the numbers to sum
  int array[ARRAY_SIZE];

  // Initialize array with values: 1, 2, 3, ...
  for (int i = 0; i < ARRAY_SIZE; i++) {
    array[i] = i + 1;
  }

  // Print the generated array for debug purposes
  for (int i = 0; i < ARRAY_SIZE; i++) {
    printf("%d ", array[i]);
  }
  printf("\n");

  // Variable for storing the number of threads
  int numThreads;

  // Get input from the user
  printf("Enter the number of threads, must be <= %d: ", MAX_THREADS);
  scanf("%d", &numThreads);

  // Check if the number of threads is within a valid range
  if (numThreads > MAX_THREADS || numThreads > ARRAY_SIZE || numThreads < 1) {
    printf("Error: Number of threads exceeds the maximum allowed or array "
           "size, or is less than 1.\n");
    return 1;
  }

  // Create an array of pthreads
  pthread_t threads[MAX_THREADS];

  // Create an array to hold thread data
  struct ThreadData threadData[MAX_THREADS];

  // Calculate the range of array elements each thread will sum
  int elementsPerThread = ARRAY_SIZE / numThreads;
  int remainingElements = ARRAY_SIZE % numThreads;
  int start = 0;

  // Create threads and assign tasks
  for (int i = 0; i < numThreads; i++) {
    threadData[i].start = start;
    threadData[i].end = start + elementsPerThread - 1;

    // If there are remaining elements distribute them in the first threads
    if (i < remainingElements) {
      threadData[i].end++; // Distribute remaining elements among first threads
    }

    // Print start and end index passed to each thread, for debug purposes
    printf("start: %d end: %d\n", threadData[i].start, threadData[i].end);

    // Copy the pointer to the array inside the i instance of the struct
    threadData[i].array = array;

    // Create the thread and execute the calculateSum function
    if (pthread_create(&threads[i], NULL, calculateSum, &threadData[i]) != 0) {
      errExit("Error creating thread");
    }

    // Move to the next range for preparing the values for the next thread
    start = threadData[i].end + 1;
  }

  // Wait for all threads to finish
  for (int i = 0; i < numThreads; i++) {
    // for each thread wait its termination
    pthread_join(threads[i], NULL);
  }

  // Calculate the final sum
  long long finalSum = 0;
  for (int i = 0; i < numThreads; i++) {
    printf("Sum %d: %lld\n", i, threadData[i].partialSum);
    finalSum += threadData[i].partialSum;
  }

  // Print the result
  printf("Sum of array elements: %lld\n", finalSum);

  // Termination without errors
  return 0;
}
