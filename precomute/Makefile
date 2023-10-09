CC = gcc
CFLAGS = -Wall -I/usr/include
LDFLAGS = -L/usr/lib
SRC_DIR = src
OBJ_DIR = obj
TARGET = main

# Find all C source files in SRC_DIR
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
# Replace .c with .o and prefix obj directory
C_OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(C_SOURCES))

all: $(TARGET)

# Link all object files to create the executable
$(TARGET): $(C_OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^ -lgmp

# Compile C source files to object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $< 

# Phony target to clean build artifacts
.PHONY: clean

clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET)

# Phony target to run the executable
.PHONY: run

run: $(TARGET)
	./$(TARGET)