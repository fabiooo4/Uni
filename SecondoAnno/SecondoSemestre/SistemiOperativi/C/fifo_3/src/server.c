#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>

#include "errExit.h"
#include "request_response.h"

char *path2ServerFIFO ="/tmp/fifo_server";
char *baseClientFIFO = "/tmp/fifo_client.";

// the file descriptor entry for the FIFO
int serverFIFO, serverFIFO_extra;

// the quit function closes the file descriptors for the FIFO,
// removes the FIFO from the file system, and terminates the process
void quit(int sig) {
    // the quit function is used as signal handler for the ALARM signal too.
    if (sig == SIGALRM)
        printf("<Server> Time expired!\n");

    // Close the FIFO
    if (serverFIFO != 0 && close(serverFIFO) == -1)
        errExit("close failed");

    if (serverFIFO_extra != 0 && close(serverFIFO_extra) == -1)
        errExit("close failed");

    // Remove the FIFO
    if (unlink(path2ServerFIFO) != 0)
        errExit("unlink failed");

    // terminate the process
    _exit(0);
}

void sendResponse(struct Request *request) {

    // make the path of client's FIFO
    char path2ClientFIFO [25];
    sprintf(path2ClientFIFO, "%s%d", baseClientFIFO, request->cPid);

    printf("<Server> opening FIFO %s...\n", path2ClientFIFO);
    // Open the client's FIFO in write-only mode
    // ...

    // Prepare the response for the client
    struct Response response;
    response.result = request->code * request->code;

    printf("<Server> sending a response\n");
    // Write the Response into the opened FIFO
    // ...

    // Close the FIFO
    // ...
}

int main (int argc, char *argv[]) {

    printf("<Server> Making FIFO...\n");
    // make a FIFO with the following permissions:
    // user:  read, write
    // group: write
    // other: no permission
    // ...

    printf("<Server> FIFO %s created!\n", path2ServerFIFO);

    // set a signal handler for SIGALRM and SIGINT signals
    // ...

    // setting a 30 seconds alarm
    // ...

    // Wait for client in read-only mode. The open blocks the calling process
    // until another process opens the same FIFO in write-only mode
    printf("<Server> waiting for a client...\n");
    // ...

    // Open an extra descriptor, so that the server does not see end-of-file
    // even if all clients closed the write end of the FIFO
    serverFIFO_extra = open(path2ServerFIFO, O_WRONLY);
    if (serverFIFO_extra == -1)
        errExit("open write-only failed");

    struct Request request;
    int bR = -1;
    do {
        printf("<Server> waiting for a Request...\n");
        // Read a request from the FIFO
        // ...

        // remove the alarm
        // ...

        // Check the number of bytes read from the FIFO
        if (/*...*/) {
            printf("<Server> it looks like the FIFO is broken\n");
        } else if (/*...*/)
            printf("<Server> it looks like I did not receive a valid request\n");
        else
            sendResponse(&request);

        // reset the alarm
        // ...
    } while (bR != -1);

    // the FIFO is broken, run quit() to remove the FIFO and
    // terminate the process.
    quit(0);
}
