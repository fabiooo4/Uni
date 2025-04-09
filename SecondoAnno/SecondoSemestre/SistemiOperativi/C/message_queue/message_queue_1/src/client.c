#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/msg.h>
#include <sys/stat.h>

#include "../inc/errExit.h"
#include "../inc/order.h"

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

  // get the message queue identifier
  int msqid = msgget(msgKey, S_IRUSR | S_IWUSR);
  if (msqid == -1)
    errExit("msgget failed");

  char buffer[10];
  size_t len;

  // create an order data struct
  struct order order;

  // by default, the order has type 1
  order.mtype = 1;

  // read the code of the client's order
  printf("Insert order code: ");
  fgets(buffer, 10, stdin);
  order.code = atoi(buffer);

  // read a description of the order
  printf("Insert a description: ");
  fgets(order.description, sizeof(order.description), stdin);
  len = strlen(order.description);
  order.description[len - 1] = '\0';

  // read a quantity
  printf("Insert quantity: ");
  fgets(buffer, 10, stdin);
  order.quantity = atoi(buffer);

  // read an e-mail
  printf("Insert an e-mail: ");
  fgets(order.email, sizeof(order.email), stdin);
  len = strlen(order.email);
  order.email[len - 1] = '\0';

  // send the order to the server through the message queue
  printf("Sending the order...\n");
  len = sizeof(struct order) - sizeof(long);
  if (msgsnd(msqid, &order, len, 0) == -1)
    errExit("msgsnd failed");

  printf("Done\n");
  return 0;
}
