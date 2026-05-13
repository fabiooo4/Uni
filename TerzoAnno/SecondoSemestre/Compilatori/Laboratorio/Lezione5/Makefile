CC = gcc
CFLAGS = -Wall
LDLIBS = -lfl
LEX = flex
YACC = yacc -d

GRAMMARS_DIR = grammars
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj

# 1. Find all .y files inside the subdirectories (e.g., grammars/calc/calc.y)
YACC_FILES = $(wildcard $(GRAMMARS_DIR)/*/*.y)

# 2. Extract just the grammar names (e.g., 'calc' from 'grammars/calc/calc.y')
GRAMMAR_NAMES = $(patsubst $(GRAMMARS_DIR)/%/,%,$(dir $(YACC_FILES)))

# 3. Automatically generate executable target names
EXECS = $(addprefix $(BUILD_DIR)/, $(GRAMMAR_NAMES))

# --- "make run [grammar_name]" or "make run grammars/[grammar_name]" ---
ifeq (run,$(firstword $(MAKECMDGOALS)))
  RUN_ARG := $(word 2, $(MAKECMDGOALS))
  ifneq ($(RUN_ARG),)
    # Turn the path into a "do-nothing" target so Make doesn't error out
    $(eval $(RUN_ARG):;@:)
    # Strip the directory path and the extension to get just the folder/grammar name
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
	@echo "  run    - Run a specific grammar (e.g., make run calc ARGS=\"file.txt\")"

# all target ---------------------------
all: $(EXECS)

# =====================================================================
# DYNAMIC RULE GENERATION (Bypasses the "double %" Make limitation)
# =====================================================================

# Define a macro template to generate explicit rules for a specific grammar
# $(1) will be replaced by the grammar name (e.g., calc)
define GRAMMAR_template
$$(BUILD_DIR)/$(1): $$(OBJ_DIR)/$(1)/y.tab.c $$(OBJ_DIR)/$(1)/lex.yy.c
	@mkdir -p $$(BUILD_DIR)
	$$(CC) $$(CFLAGS) -I$$(OBJ_DIR)/$(1) $$^ -o $$@ $$(LDLIBS)

$$(OBJ_DIR)/$(1)/y.tab.c: $$(GRAMMARS_DIR)/$(1)/$(1).y
	@mkdir -p $$(OBJ_DIR)/$(1)
	$$(YACC) -o $$@ $$<

$$(OBJ_DIR)/$(1)/y.tab.h: $$(OBJ_DIR)/$(1)/y.tab.c
	@touch $$@

$$(OBJ_DIR)/$(1)/lex.yy.c: $$(GRAMMARS_DIR)/$(1)/$(1).l $$(OBJ_DIR)/$(1)/y.tab.h
	@mkdir -p $$(OBJ_DIR)/$(1)
	$$(LEX) -o $$@ $$<
endef

# Loop through all found grammars and stamp out the template rules for them
$(foreach prog,$(GRAMMAR_NAMES),$(eval $(call GRAMMAR_template,$(prog))))

# =====================================================================

# run target ----------------------------------------------
run:
	@if [ -z "$(RUN_GRAMMAR)" ]; then \
		echo "Error: Missing grammar path. Usage: make run calc"; \
		exit 1; \
	fi
	@$(MAKE) $(BUILD_DIR)/$(RUN_GRAMMAR)
	./$(BUILD_DIR)/$(RUN_GRAMMAR) $(ARGS)
# run target ----------------------------------------------

# clean target --------------------------------------------
clean:
	rm -rf $(BUILD_DIR)/
# clean target --------------------------------------------
