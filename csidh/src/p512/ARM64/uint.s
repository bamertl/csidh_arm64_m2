.text
.global _uint_0
_uint_0:
    .quad 0x0000000000000000
    .quad 0x0000000000000000
    .quad 0x0000000000000000
    .quad 0x0000000000000000
    .quad 0x0000000000000000
    .quad 0x0000000000000000
    .quad 0x0000000000000000
    .quad 0x0000000000000000

.global _uint_1
_uint_1:
    .quad 0x0000000000000001
    .quad 0x0000000000000000
    .quad 0x0000000000000000
    .quad 0x0000000000000000
    .quad 0x0000000000000000
    .quad 0x0000000000000000
    .quad 0x0000000000000000
    .quad 0x0000000000000000


.macro LOAD_8_WORD_NUMBER, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, num_pointer
    LDP \reg1, \reg2, [\num_pointer,#0] 
    LDP \reg3, \reg4, [\num_pointer,#16]
    LDP \reg5, \reg6, [\num_pointer,#32]
    LDP \reg7, \reg8, [\num_pointer, #48]
.endm

.macro STORE_8_WORD_NUMBER, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, destination_pointer
    STP \reg1, \reg2, [\destination_pointer,#0] 
    STP \reg3, \reg4, [\destination_pointer,#16]
    STP \reg5, \reg6, [\destination_pointer,#32]
    STP \reg7, \reg8, [\destination_pointer, #48]
.endm

/* x0 = x0 == x1 */
.global _uint_eq
_uint_eq:
    // Load 1st pair of elements and compute XOR
    ldr x2, [x0]
    ldr x3, [x1]
    eor x2, x2, x3
    // Load 2nd pair of elements and compute XOR
    ldr x3, [x0, #8]
    ldr x4, [x1, #8]
    eor x3, x3, x4
    orr x2, x2, x3
    // Load 3rd pair of elements and compute XOR
    ldr x3, [x0, #16]
    ldr x4, [x1, #16]
    eor x3, x3, x4
    orr x2, x2, x3
    // Load 4th pair of elements and compute XOR
    ldr x3, [x0, #24]
    ldr x4, [x1, #24]
    eor x3, x3, x4
    orr x2, x2, x3
    // Load 5th pair of elements and compute XOR
    ldr x3, [x0, #32]
    ldr x4, [x1, #32]
    eor x3, x3, x4
    orr x2, x2, x3
    // Load 6th pair of elements and compute XOR
    ldr x3, [x0, #40]
    ldr x4, [x1, #40]
    eor x3, x3, x4
    orr x2, x2, x3
    // Load 7th pair of elements and compute XOR
    ldr x3, [x0, #48]
    ldr x4, [x1, #48]
    eor x3, x3, x4
    orr x2, x2, x3
    // Load 8th pair of elements and compute XOR
    ldr x3, [x0, #56]
    ldr x4, [x1, #56]
    eor x3, x3, x4
    orr x2, x2, x3
    // Return the logical NOT of the accumulated result
    cmp x2, #0
    cset w0, eq           // Set w0 to 1 if equal (i.e., x2 is 0), 0 otherwise
    ret


/*
Operation x0[0] = x1, rest of x0 = 0
 */
.global _uint_set
_uint_set:
    // Store y (in X1) to the memory location pointed by x (in X0)
    str x1, [x0]
    mov x1, xzr // x1 = 0
    // Store 0 to the next 7 memory locations
    str x1, [x0, #8]   // 2nd element
    str x1, [x0, #16]  // 3rd element
    str x1, [x0, #24]  // 4th element
    str x1, [x0, #32]  // 5th element
    str x1, [x0, #40]  // 6th element
    str x1, [x0, #48]  // 7th element
    str x1, [x0, #56]  // 8th element
    ret

/*
get position most significant non zero bit, i dont know if it start by 1 or 0
todo: test this if it start by 0 or 1
 */
.global _uint_len
_uint_len:

    mov x3, x0
    mov x0, #0          // current result
    mov x16, #64
    // First element
    mov x2, #0          // current limb bit offset 0 - 448 (7*64)

    ldr x4, [x3, #0]    // Load the 1th limb
    clz x5, x4          // Count leading zeros in x4
    sub x5, x16, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Second element
    add x2, x2, x16         // add 64 to limb offset
    ldr x4, [x3, #8]
    clz x5, x4          // Count leading zeros in x4
    sub x5, x16, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Third
    add x2,x2, x16         // add 64 to limb offset
    ldr x4, [x3, #16]
    clz x5, x4          // Count leading zeros in x4
    sub x5, x16, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Fourth
    add x2, x2, x16         // add 64 to limb offset
    ldr x4, [x3, #24]
    clz x5, x4          // Count leading zeros in x4
    sub x5, x16, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Fifth
    add x2, x2, x16         // add 64 to limb offset
    ldr x4, [x3, #32]
    clz x5, x4          // Count leading zeros in x4
    sub x5, x16, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Sixth
    add x2, x2, #64         // add 64 to limb offset
    ldr x4, [x3, #40]
    clz x5, x4          // Count leading zeros in x4
    sub x5, x16, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Seventh
    add x2, x2, #64         // add 64 to limb offset
    ldr x4, [x3, #48]
    clz x5, x4          // Count leading zeros in x4
    sub x5, x16, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Eigth
    add x2, x2, #64         // add 64 to limb offset
    ldr x4, [x3, #56]
    clz x5, x4          // Count leading zeros in x4
    sub x5, x16, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result
    ret

/*
Check if bit at position x1 is set in array of x0
 x1 position: 0-511 
 x0 array of number 8*64 bit
 */
.global _uint_bit
_uint_bit:
    and x2, x1, #0x3F   // x2 = x0 % 64 using bitwise AND
    lsr x1, x1, #6      // x1 = x1 / 64 by right-shifting

    lsl x1, x1, #3      // 8 * (x1 / 64)
    ldr x3, [x0, x1]    // Load the limb at: x0 + 8 * (k / 64)
    lsr x3, x3, x2  // Right shift by x0%64 to bring the bit of interest to the least significant position
    and x0, x3, #1  // Check if the least significant bit is set
    ret

/*
c[x0] = a[x1] + b[x2]
x0 = carry
 */
.global _uint_add3
_uint_add3:

    sub sp, sp, #16
    stp x19, x20, [sp, #0]

    LOAD_8_WORD_NUMBER x3, x4, x5, x6, x7, x8, x9, x10, x1 // load number x1
    LOAD_8_WORD_NUMBER x12, x13, x14, x15, x16, x17, x19, x20, x2 // load number x2

    // Add x0 + x1 with carry into register X0
    adds x3, x3, x12 
    adcs x4, x4, x13
    adcs x5, x5, x14
    adcs x6, x6, x15
    adcs x7, x7, x16
    adcs x8, x8, x17
    adcs x9, x9, x19
    adcs x10, x10, x20
    adc x11, xzr, xzr // carry into x11

    STORE_8_WORD_NUMBER x3, x4, x5, x6, x7, x8, x9, x10, x0 // store a + b into x0
    mov x0, x11

    ldp x19, x20, [sp, #0]
    add sp, sp, #16

    ret

/*
c[x0] = a[x1] - b[x2]
x0 = carry
 */
.global _uint_sub3
_uint_sub3:

    sub sp, sp, #16
    stp x19, x20, [sp, #0]

    LOAD_8_WORD_NUMBER x3, x4, x5, x6, x7, x8, x9, x10, x1 // load number x1
    LOAD_8_WORD_NUMBER x12, x13, x14, x15, x16, x17, x19, x20, x2 // load number x2

    subs x3, x3, x12
    sbcs x4, x4, x13
    sbcs x5, x5, x14
    sbcs x6, x6, x15
    sbcs x7, x7, x16
    sbcs x8, x8, x17
    sbcs x9, x9, x19
    sbcs x10, x10, x20
    sbc x11, xzr, xzr // sub with carry into x11

    STORE_8_WORD_NUMBER x3, x4, x5, x6, x7, x8, x9, x10, x0 // store a-b into x2
    mov x0, x11 // x11 to x0
    ldp x19, x20, [sp, #0]
    add sp, sp , #16
    ret
/*
c[x0] = a[x1] * b[x2]
b = direct value not address of 64 bit
 */
.global _uint_mul3_64
_uint_mul3_64:

    // First limb
    ldr x4, [x1, #0]   // load limb
    umulh x5, x4, x2   // high 
    mul x4, x4, x2     // low
    str x4, [x0, #0]

    // Second Limb
    ldr x4, [x1, #8]    // load limb
    mul x4, x4, x2      // low
    adds x4, x4, x5     // add past lower (x5)
    str x4, [x0, #8]
    umulh x5, x4, x2    // high

    // Third Limb
    ldr x4, [x1, #16]    // load limb
    mul x4, x4, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #16]
    umulh x5, x4, x2    // high

    // Fourth Limb
    ldr x4, [x1, #24]    // load limb
    mul x4, x4, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #24]
    umulh x5, x4, x2    // high

    // Limb Numero 5
    ldr x4, [x1, #32]    // load limb
    mul x4, x4, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #32]
    umulh x5, x4, x2    // high

    // Limb Numero 6
    ldr x4, [x1, #40]    // load limb
    mul x4, x4, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #40]
    umulh x5, x4, x2    // high

    // Limb Numero 7
    ldr x4, [x1, #48]    // load limb
    mul x4, x4, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #48]
    umulh x5, x4, x2    // high

    // Limb Numero 8
    ldr x4, [x1, #56]    // load limb
    mul x4, x4, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #56]
    umulh x5, x4, x2    // high
    ret
/*
x0: place to store random number
x1: uniformly distributed in (0,x1)
for now just filling the full bytes

todo we might need to change this here a bit, they have some odd logic if x1 is 0
 */
.global _uint_random
_uint_random:

    sub sp, sp, #48
    stp lr, x0, [sp, #0]
    str x1, [sp, #16]
    mov x0, x1
    bl _uint_len //get the number of valid bits in m

    mov x1, x0 // save result in x1
    lsr x3, x1, #3        // x3 = total bits / 8 = Bytes
    and x4, x1, #0x3f      // x4 = remainder bits % 64

    mov x1, x3
    ldr x0, [sp, #8]
    bl _randombytes

    ldr x0, [sp, #8] // the function does return some different value in x0
    ldr lr, [sp, #0]
    add sp, sp, #48
    ret
