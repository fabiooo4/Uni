
CFLAGS=-Wall -std=gnu99
INCLUDES=-I./inc

SERVER_SRCS=src/errExit.c src/server.c src/order.c
CLIENT_SRCS=src/errExit.c src/client.c

SERVER_OBJS=$(SERVER_SRCS:.c=.o)
CLIENT_OBJS=$(CLIENT_SRCS:.c=.o)

all: server client

server: $(SERVER_OBJS)
	@echo "Making executable: "$@
	@$(CC) $^ -o $@

client: $(CLIENT_OBJS)
	@echo "Making executable: "$@
	@$(CC) $^ -o $@

.c.o:
	@echo "Compiling: "$<
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

.PHONY: clean

clean:
	@rm -f src/*.o client server
	@echo "Removed object files and executables..."
