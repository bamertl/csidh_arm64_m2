.global hello

.section .data
msg:    .ascii "Hello, ARM64!\n"
len = . - msg

.section .text
hello:
    mov x0, 1          // File descriptor: STDOUT
    ldr x1, =msg       // Pointer to the message
    ldr x2, =len       // Length of the message
    mov x8, 64         // Syscall number: write
    svc 0              // Make syscall
    ret
