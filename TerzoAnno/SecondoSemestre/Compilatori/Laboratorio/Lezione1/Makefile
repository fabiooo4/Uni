CC = gcc
CFLAGS = -Wall
LDLIBS = -lfl
LEX = flex
BUILD_DIR = build
GRAMMAR = grammar

.PHONY: targets all clean run

targets:
	@echo "Usage: make [target]"
	@echo "Available targets:"
	@echo "  all     - Build the project"
	@echo "  clean   - Clean the build artifacts"
	@echo "  run     - Run the lexer (use ARGS=\"...\" to pass parameters)"

# all target (previously build) ---------------------------
all: $(BUILD_DIR)/$(GRAMMAR)

$(BUILD_DIR)/$(GRAMMAR): $(BUILD_DIR)/lex.yy.c
	$(CC) $(CFLAGS) $< -o $@ $(LDLIBS)

$(BUILD_DIR)/lex.yy.c: $(GRAMMAR).l | $(BUILD_DIR)
	$(LEX) -o $@ $<

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
# all target ----------------------------------------------

# run target ----------------------------------------------
run: all
	./$(BUILD_DIR)/$(GRAMMAR) $(ARGS)
# run target ----------------------------------------------

# clean target --------------------------------------------
clean:
	rm -rf $(BUILD_DIR)/
# clean target --------------------------------------------
