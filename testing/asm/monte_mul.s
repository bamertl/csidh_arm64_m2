.global monte_mul
.section .text

/*
x0 = uint A, x1= uintB B, x2=result pointer
This calculates A*B mod P
*/
monte_mul:
    // C <- 0
    mov x3, #0
    mov x4, #0
    mov x5, #0
    mov x6, #0
    mov x7, #0
    mov x8, #0
    mov x9, #0
    mov x10, #0
    
    // i = 0, n=n
    ldr x11, #0
    ldr x12, n
    

/* i=x11, n=x12 */
_loop:
    cmp x11, x12      // Compare i (w0) with n (w1)
    b.ge endloop    // If i >= n, exit loopcmp x0, x1
    add x3, x3, #1

    add x11, x11, #1  // Increment i (w0) by 1
    b loop          // Jump back to the start of the loop


_end_loop:
    ret

