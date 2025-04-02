#include "../inc/errExit.h"
#include <fcntl.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  // Check command line input arguments
  // The program only wants a FIFO pathname
  if (argc != 2) {
    printf("Usage: %s fifo_pathname\n", argv[0]);
    return 0;
  }

  // Read the FIFO's pathname
  char *path2ServerFIFO = argv[1];

  printf("<Client> opening FIFO %s...\n", path2ServerFIFO);
  // Open the FIFO in write-only mode
  int serverFIFO = open(path2ServerFIFO, O_WRONLY);
  if (serverFIFO == -1)
    errExit("open failed");

  int v[] = {0, -1};
  while (v[0] != v[1]) {
    printf("<Client> Give me two numbers: ");
    scanf("%d %d", &v[0], &v[1]);

    printf("<Client> sending %d %d\n", v[0], v[1]);
    // Write two integers to the opened FIFO
    if (write(serverFIFO, v, sizeof(v)) != sizeof(v))
      errExit("write failed");
  }

  // Close the FIFO
  if (close(serverFIFO) != 0)
    errExit("close failed");
}
