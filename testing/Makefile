# Define cross-compiler and assembler
CC = cc
# Flags

# Folders
SRC_DIR = src
ASM_DIR = asm
OBJ_DIR = obj
TEST_DIR = tests

# Exclude main.o from test builds
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
C_SOURCES_NO_MAIN = $(filter-out $(SRC_DIR)/main.c, $(C_SOURCES))
# Test targets
TEST_SOURCES = $(wildcard $(TEST_DIR)/test_*.c)
TEST_EXECUTABLES = $(patsubst $(TEST_DIR)/%.c, $(TEST_DIR)/%, $(TEST_SOURCES))

# Test target
.PHONY: test

# Build targets
ASM_SOURCES = $(wildcard $(ASM_DIR)/*.s)

test: $(TEST_EXECUTABLES)
	@echo "Running tests..."
	@for executable in $^; do \
		echo "Running $$executable..."; \
		./$$executable; \
		if [ $$? -eq 0 ]; then \
			echo "$$executable passed"; \
		else \
			echo "$$executable failed"; \
		fi; \
	done

$(TEST_DIR)/%: $(TEST_DIR)/%.c $(C_SOURCES_NO_MAIN) $(ASM_SOURCES)
	@cc \
	-I ./src \
	-g \
	-o $@ $< $(C_SOURCES_NO_MAIN) $(ASM_SOURCES) 

# Targets
all: main

main: $(C_SOURCES) $(ASM_SOURCES)
	cc \
		-I ./src  \
		-I ./asm \
		-o main $(C_SOURCES) $(ASM_SOURCES)

# Phony targets
.PHONY: clean run	

clean:
	rm -f $(OBJ_DIR)/*.o main

	find $(TEST_DIR) -type f ! -name "*.*" ! -name "*.c" -exec rm -f {} \;
run: main
	./main
