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


# Build targets
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
ASM_SOURCES = $(wildcard $(ASM_DIR)/*.s)
C_OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(C_SOURCES))
ASM_OBJECTS = $(patsubst $(ASM_DIR)/%.s, $(OBJ_DIR)/%.o, $(ASM_SOURCES))

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

run: main
	qemu-aarch64 ./main
