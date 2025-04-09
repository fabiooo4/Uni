#include <signal.h>
#include <stdio.h>
#include <stdlib.h>

#include <sys/ipc.h>
#include <sys/msg.h>
#include <sys/stat.h>

#include "../inc/errExit.h"
#include "../inc/order.h"

// the message queue identifier
int msqid = -1;

void signTermHandler(int sig) {
  // do we have a valid message queue identifier?
  if (msqid > 0) {
    if (msgctl(msqid, IPC_RMID, NULL) == -1)
      errExit("msgctl failed");
    else
      printf("<Server> Message queue removed successfully\n");
  }

  // terminate the server process
  exit(0);
}

int main(int argc, char *argv[]) {
  // check command line input arguments
  if (argc != 2) {
    printf("Usage: %s message_queue_key\n", argv[0]);
    exit(1);
  }

  // read the message queue key defined by user
  int msgKey = atoi(argv[1]);
  if (msgKey <= 0) {
    printf("The message queue key must be greater than zero!\n");
    exit(1);
  }

  // set the function sigHandler as handler for the signals SIGINT, SIGTERM and
  // SIGHUP
  if (signal(SIGINT, signTermHandler) == SIG_ERR)
    errExit("signal failed");
  if (signal(SIGTERM, signTermHandler) == SIG_ERR)
    errExit("signal failed");
  if (signal(SIGHUP, signTermHandler) == SIG_ERR)
    errExit("signal failed");

  printf("<Server> Making MSG queue...\n");
  // get the message queue, or create a new one if it does not exist
  msqid = msgget(msgKey, IPC_CREAT | S_IRUSR | S_IWUSR);
  if (msqid == -1)
    errExit("msgget failed");

  struct order order;

  // endless loop
  while (1) {
    // read a message from the message queue
    size_t mSize = sizeof(struct order) - sizeof(long);
    if (msgrcv(msqid, &order, mSize, 0, 0) == -1)
      errExit("msgrcv failed");

    // print the order on standard output
    printOrder(&order);
  }
}
