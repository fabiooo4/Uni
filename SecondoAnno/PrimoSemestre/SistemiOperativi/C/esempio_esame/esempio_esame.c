#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
  int pid = fork();

  if (pid < 0) {
    printf("Errore di creazione\n");
    exit(-1);
  } else if (pid == 0) {
    // Codice del processo figlio
    while (1) {
      printf("STO FIGLIANDO!\n");
    }
  } else {
    // Codice del processo padre
    sleep(2);
    kill(pid, SIGTERM);
    printf("FIGLIO KILLATOOOOO!\n");
    wait(NULL);
  }

  exit(0);
}
