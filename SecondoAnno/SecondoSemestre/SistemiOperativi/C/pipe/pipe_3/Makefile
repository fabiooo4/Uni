NAME=ping2pong
CFLAGS=-Wall -std=gnu99
INCLUDES=-I./inc

SRCS=src/errExit.c src/main.c
OBJS=$(SRCS:.c=.o)

$(NAME): $(OBJS)
	@echo "Making executable: "$@
	@$(CC) $^ -o $@

.c.o:
	@echo "Compiling: "$<
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

.PHONY: clean

clean:
	@rm -f src/*.o $(NAME)
	@echo "Removed object files and executable..."
