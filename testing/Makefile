# Define cross-compiler and assembler
CC = clang
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

# Build targets
ASM_SOURCES = $(wildcard $(ASM_DIR)/*.S)

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
	${CC} -g  -I ./src/asm/ $(ASM_SOURCES) $(C_SOURCES_NO_MAIN) $<  -o $@ 

# Targets
all: main

main: $(C_SOURCES) $(ASM_SOURCES)
	@${CC} \
		$(C_SOURCES) $(ASM_SOURCES) \
		-o main

# Phony targets
.PHONY: clean run	

clean:
	rm -f $(OBJ_DIR)/*.o main

	find $(TEST_DIR) -type f ! -name "*.*" ! -name "*.c" -exec rm -f {} \;
run: main
	./main
