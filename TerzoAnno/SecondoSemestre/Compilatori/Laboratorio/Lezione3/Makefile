CC = gcc
CFLAGS = -Wall
LDLIBS = -lfl
LEX = flex

GRAMMARS_DIR = grammars
BUILD_DIR = build

# Find all .l files in the grammars folder
LEX_FILES = $(wildcard $(GRAMMARS_DIR)/*.l)

# Automatically generate the executable names we want in the build/ folder
EXECS = $(patsubst $(GRAMMARS_DIR)/%.l, $(BUILD_DIR)/%, $(LEX_FILES))

# --- "make run path/to/grammar.l" ---
ifeq (run,$(firstword $(MAKECMDGOALS)))
  # Grab the second argument (the path)
  RUN_ARG := $(word 2, $(MAKECMDGOALS))
  ifneq ($(RUN_ARG),)
    # Turn the path into a "do-nothing" target so Make doesn't error out
    $(eval $(RUN_ARG):;@:)
    # Strip the directory path and the .l extension to get just the name
    RUN_GRAMMAR := $(basename $(notdir $(RUN_ARG)))
  endif
endif
# ---------------------------------------------------------

.PHONY: targets all clean run

targets:
	@echo "Usage: make [target]"
	@echo "Available targets:"
	@echo "  all    - Build all grammars in $(GRAMMARS_DIR)/"
	@echo "  clean  - Clean the build artifacts"
	@echo "  run    - Run a specific grammar (e.g., make run grammars/html.l ARGS=\"file.txt\")"

# all target ---------------------------
all: $(EXECS)

# Pattern rule: How to link an executable from a compiled C file
$(BUILD_DIR)/%: $(BUILD_DIR)/%.yy.c
	$(CC) $(CFLAGS) $< -o $@ $(LDLIBS)

# Pattern rule: How to generate a C file from a lex file
$(BUILD_DIR)/%.yy.c: $(GRAMMARS_DIR)/%.l | $(BUILD_DIR)
	$(LEX) -o $@ $<

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
# all target ----------------------------------------------

# run target ----------------------------------------------
run:
	@if [ -z "$(RUN_GRAMMAR)" ]; then \
		echo "Error: Missing grammar path. Usage: make run path/to/grammar.l"; \
		exit 1; \
	fi
	@$(MAKE) $(BUILD_DIR)/$(RUN_GRAMMAR)
	./$(BUILD_DIR)/$(RUN_GRAMMAR) $(ARGS)
# run target ----------------------------------------------

# clean target --------------------------------------------
clean:
	rm -rf $(BUILD_DIR)/
# clean target --------------------------------------------
