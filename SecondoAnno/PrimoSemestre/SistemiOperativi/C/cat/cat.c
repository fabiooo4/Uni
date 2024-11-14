#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <threads.h>
#include <unistd.h>

#define EXIT_SUCCESS 0
#define EXIT_ERROR 1

extern int errno;

void print_error() {
  // Print which type of error occurs
  printf("Error %d:\n", errno);
  perror("");
  exit(EXIT_ERROR);
}

// Utilizzando solamente le system call open e read, e la funzione printf,
// realizzare un programma che simuli il comportamento del comando cat.
// Utilizzo: my_cat <file1> … <filen>.
int main(int argc, char *argv[]) {
  // If no args are provided
  if (argc <= 1) {
    // Print help of the command
    printf("Usage:\n\ncat <file>\n");
    return EXIT_SUCCESS;
  }

  for (int i = 1; i < argc; i++) {
    // First argument
    char *path = argv[i];

    if (path == NULL) {
      // Print which type of error occurs
      print_error();
    }

    // Open the path provided by the arguments
    int fd = open(path, O_RDONLY);

    // Check if file exists
    if (fd == -1) {
      print_error();
    }

    // Buffer
    char buf[1];

    // Print the contents of the file
    int result = 1;
    while (result) {
      result = read(fd, buf, 1);
      if (result) {
        printf("%s", buf);
      }
    }

    if (result == -1) {
      print_error();
    }
  }

  return EXIT_SUCCESS;
}
