.global _uint_set
.global _uint_eq

/* x0 = x0 == x1 */
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
.global uint_len
_uint_len:

    mov x0, #0          // current result

    // First element
    mov x2, #0          // current limb bit offset 0 - 448 (7*64)

    ldr x4, [x0, #0]    // Load the 1th limb
    clz x5, x4          // Count leading zeros in x4
    sub x5, #64, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Second element
    add x2, #64         // add 64 to limb offset
    ldr x4, [x0, #8]
    clz x5, x4          // Count leading zeros in x4
    sub x5, #64, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Third
    add x2, #64         // add 64 to limb offset
    ldr x4, [x0, #16]
    clz x5, x4          // Count leading zeros in x4
    sub x5, #64, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Fourth
    add x2, #64         // add 64 to limb offset
    ldr x4, [x0, #24]
    clz x5, x4          // Count leading zeros in x4
    sub x5, #64, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Fifth
    add x2, #64         // add 64 to limb offset
    ldr x4, [x0, #32]
    clz x5, x4          // Count leading zeros in x4
    sub x5, #64, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Sixth
    add x2, #64         // add 64 to limb offset
    ldr x4, [x0, #40]
    clz x5, x4          // Count leading zeros in x4
    sub x5, #64, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Seventh
    add x2, #64         // add 64 to limb offset
    ldr x4, [x0, #48]
    clz x5, x4          // Count leading zeros in x4
    sub x5, #64, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    // Eigth
    add x2, #64         // add 64 to limb offset
    ldr x4, [x0, #56]
    clz x5, x4          // Count leading zeros in x4
    sub x5, #64, x5     // position of first bit or 0
    add x5, x5, x2      // add limb offset
    cmp x5, x2          // compare if x5 == x2
    csel x0, x5, x0, ne // if x5==x2 keep result else choose new result

    ret

/*
Check if bit at position x1 is set in array of x0
 x1 position: 0-511 
 x0 array of number 8*64 bit
 */
.global uint_bit
uint_bit:
    and x2, x1, #0x3F   // x2 = x0 % 64 using bitwise AND
    lsr x1, x1, #6      // x1 = x1 / 64 by right-shifting

    lsl x1, x1, #3      // 8 * (x1 / 64)
    ldr x3, [x0, x1]    // Load the limb at: x0 + 8 * (k / 64)
    lsr x3, x3, x2  // Right shift by x0%64 to bring the bit of interest to the least significant position
    and x0, x3, #1  // Check if the least significant bit is set
    ret

