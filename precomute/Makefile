CC = gcc
CFLAGS = -Wall -I/usr/include
LDFLAGS = -L/usr/lib
SRC_DIR = src
OBJ_DIR = obj
TARGET = main
HELPER_TARGET = helper

# Find all C source files in SRC_DIR
C_SOURCES = $(wildcard $(SRC_DIR)/*.c)
# Replace .c with .o and prefix obj directory
C_OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(C_SOURCES))

all: $(TARGET)

# Link all object files to create the main executable
$(TARGET): $(filter-out $(OBJ_DIR)/helper.o, $(C_OBJECTS))
	$(CC) $(LDFLAGS) -o $@ $^ -lgmp

# Rule for the helper executable
$(HELPER_TARGET): $(OBJ_DIR)/helper.o
	$(CC) $(LDFLAGS) -o $@ $^ -lgmp

# Compile C source files to object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $< 

# Phony target to clean build artifacts
.PHONY: clean

clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET) $(HELPER_TARGET)

# Phony target to run the main executable
.PHONY: run

run: $(TARGET)
	./$(TARGET)

# Phony target to run the helper executable
.PHONY: run_helper

run_helper: $(HELPER_TARGET)
	./$(HELPER_TARGET)
