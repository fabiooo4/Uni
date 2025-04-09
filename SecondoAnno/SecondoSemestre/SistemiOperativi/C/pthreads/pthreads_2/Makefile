NAME=ese_2_threads
CFLAGS=-Wall -std=c99 -Wextra -pthread
INCLUDES=-I./inc

SRCS=src/main.c
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
