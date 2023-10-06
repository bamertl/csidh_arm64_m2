# Some info for debugging


# Terminal 1
qemu-aarch64 -g 1234 ./main

# Terminal 2
gdb-multiarch ./main
target remote :1234