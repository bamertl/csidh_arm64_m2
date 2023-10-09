# Define cross-compiler and assembler
CC := aarch64-linux-gnu-gcc
AS := aarch64-linux-gnu-as


# Flags
CFLAGS = -Wall -static
LDFLAGS = -Wall -static

# Folders
SRC_DIR = src
ASM_DIR = asm
OBJ_DIR = obj
TEST_DIR = tests

# Exclude main.o from test builds
C_OBJECTS_NO_MAIN = $(filter-out $(OBJ_DIR)/main.o, $(C_OBJECTS))
# Test targets
TEST_SOURCES = $(wildcard $(TEST_DIR)/test_*.c)
TEST_OBJECTS = $(patsubst $(TEST_DIR)/%.c, $(OBJ_DIR)/%.o, $(TEST_SOURCES))
TEST_EXECUTABLES = $(patsubst $(TEST_DIR)/%.c, $(TEST_DIR)/%, $(TEST_SOURCES))

# Test target
.PHONY: test

# Build targets
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
ASM_SOURCES = $(wildcard $(ASM_DIR)/*.s)
C_OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(C_SOURCES))
ASM_OBJECTS = $(patsubst $(ASM_DIR)/%.s, $(OBJ_DIR)/%.o, $(ASM_SOURCES))

test: $(TEST_EXECUTABLES)
	@echo "Running tests..."
	@for executable in $^; do \
		echo "Running $$executable..."; \
		qemu-aarch64 ./$$executable; \
		if [ $$? -eq 0 ]; then \
			echo "$$executable passed"; \
		else \
			echo "$$executable failed"; \
		fi; \
	done

$(TEST_DIR)/%: $(TEST_DIR)/%.c $(C_OBJECTS_NO_MAIN) $(ASM_OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< $(C_OBJECTS_NO_MAIN) $(ASM_OBJECTS) 

# Targets
all: main

main: $(C_OBJECTS) $(ASM_OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ_DIR)/%.o: $(ASM_DIR)/%.s
	$(AS) $(ASFLAGS) -o $@ $<

# Phony targets
.PHONY: clean run	

clean:
	rm -f $(OBJ_DIR)/*.o main

	find $(TEST_DIR) -type f ! -name "*.*" ! -name "*.c" -exec rm -f {} \;
run: main
	qemu-aarch64 ./main
