# Define cross-compiler and assembler
CC := aarch64-linux-gnu-gcc
AS := aarch64-linux-gnu-as

# Flags
CFLAGS := -Wall -g
ASFLAGS := 

# Build targets
all: main

main: main.o hello.o
	$(CC) -static -o $@ $^

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

hello.o: hello.s
	$(AS) $(ASFLAGS) -o $@ $<

# Phony targets
.PHONY: clean run

clean:
	rm -f *.o main

run: main
	qemu-aarch64 ./main
