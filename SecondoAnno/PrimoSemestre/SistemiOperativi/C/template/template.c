#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
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

// Crea un file con il contenuto
//
// #include <stdio.h>
// int main(....) {
//   ....
// }
int main(int argc, char *argv[]) {
  // If no args are provided
  if (argc <= 1) {
    // Print help of the command
    printf("Usage:\n\ncat [FILE]...\n");
    return EXIT_SUCCESS;
  }

  // First argument
  char *path = argv[1];

  if (path == NULL) {
    // Print which type of error occurs
    print_error();
  }

  // Open the path provided by the arguments
  int fd = open(path, O_CREAT | O_WRONLY,
                S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH);

  if (fd == -1) {
    print_error();
  }

  // Buffer
  char *template = "#include<stdio.h>\nint main(....){\n\t....\n}";

  // Print the contents of the file
  ssize_t result = write(fd, template, strlen(template));

  if (result == -1 || result < (ssize_t)strlen(template)) {
    print_error();
  }

  return EXIT_SUCCESS;
}
