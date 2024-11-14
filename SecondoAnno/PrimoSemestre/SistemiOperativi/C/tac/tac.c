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

// Utilizzando solamente le system call open, read, lseek, e write, realizzare
// un programma che simuli il  comportamento del comando tac. Al contrario di
// cat, il comando tac stampa il contenuto di un file al  contrario (dall’ultimo
// carattere al primo)
// Utilizzo:    my_tac <file1> … <filen>
int main(int argc, char *argv[]) {
  // If no args are provided
  if (argc <= 1) {
    // Print help of the command
    printf("Usage:\n\ntac [FILE]...\n");
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
    int lseek_res = lseek(fd, 0, SEEK_END); // Set cursor to the end of the file
    int read_res = 1;

    while (read_res && lseek_res > 0) {
      // Decrement the cursor by 2 because read increments it by 1
      lseek_res = lseek(fd, -2, SEEK_CUR);

      read_res = read(fd, buf, 1);

      if (read_res) {
        printf("%s", buf);
      }
    }

    if (read_res == -1 || lseek_res == -1) {
      print_error();
    }
  }

  return EXIT_SUCCESS;
}
