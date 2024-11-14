#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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

// Realizzare un programma che sfruttando le system call per la gestione dei
// file esegua un search_replace  di una stringa all’interno di un file.
//
// search_replace <source file> <destination file> <search> <replace>
//
// Il programma copia il contenuto del file <source file> in un nuovo
// file di nome <destination file>.  Dovrà  sostituire tutte le occorrenze di
// <string search> con <string replace>.
int main(int argc, char *argv[]) {
  // If no args are provided
  if (argc <= 1) {
    // Print help of the command
    printf("Usage:\n\nsearch_replace [FILE]...\n");
    return EXIT_SUCCESS;
  }

  // Arguments
  char *src = argv[1];
  char *dst = argv[2];
  char *search = argv[3];
  char *replace = argv[4];

  if (src == NULL || dst == NULL || search == NULL || replace == NULL) {
    // Print which type of error occurs
    print_error();
  }

  // Open the path provided by the arguments
  int src_fd = open(src, O_RDONLY);

  // Open the destination file (or create it if it doesnt exist)
  int dst_fd = open(dst, O_CREAT | O_WRONLY,
                    0400 | 0200 | (0400 >> 3) | ((0400 >> 3) >> 3));

  // Check if files opened correctly
  if (src_fd == -1 || dst_fd == -1) {
    print_error();
  }

  // Buffer
  char buf[1];
  char lines[10000];

  // Print the contents of the file
  int result = 1;
  int ch = 0;
  while (result) {
  result = read(src_fd, buf, 1);

    if (result) {
      lines[ch] = buf[0];
      ch++;
    }
  }

  if (result == -1) {
    print_error();
  }

  printf("%s",lines);

  return EXIT_SUCCESS;
}
