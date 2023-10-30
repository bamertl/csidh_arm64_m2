.extern _p
.extern _inv_min_p_mod_r
.extern _uint_mul3_64
.extern _uint_add3

/*
Montgomery multiplication
C[x0] = A[x1] * B[x2] % p
r = 2^64
n = 8
R = r^n = 2^512

 */
.global _fp_mul3
_fp_mul3:

sub sp, sp, #224 // 0-64 lr,x0,x1,x2,x17,19,x20,x21
// Address C = sp + #8
// Address A = sp + #16
// Address B = sp + #24
// C = sp + 64-128, temp = sp + 128-200 !! temp is 9 words
// Counter = sp + 200
// Offset = i * 8 = sp + 208

stp lr, x0, [sp, #0]
stp x1, x2, [sp, #16]
stp x17, x19, [sp, #32]
stp x20, x21, [sp, #48]

// C <- 0 
mov x0, #0
stp x0, x0, [sp, #64]
stp x0, x0, [sp, #80]
stp x0, x0, [sp, #96]
stp x0, x0, [sp, #112]

// i = 0
mov x5, #0
str x5, [sp, #200]
// offset = i * 8
mov x6, #0
str x6, [sp, #208]

_fp_mul_loop:
    // 1. C <- C + a[i] * B
    ldr x2, [sp, #16] // load address of A
    add x2, x2, x6 // add offset 
    ldr x2, [x2] //  value a[i]
    ldr x1, [sp, #24] // load address of B 
    add x0, sp, #128 // temp Address

    // a[i] * B
    bl _uint_mul3_64 // x0 = x1 * x2 (x2 = uint64_t)
    mov x1, x0 // x1 = a[i] * B
    add x0, sp, #64 // load address of C
    mov x2, x0
    bl _uint_add3 // C <- C + temp(a[i] * B)

    // 2. q ← C*mu mod r

    add x0, sp, #128 // temp address
    add x1, sp, #64 // C address
    adrp x2, _inv_min_p_mod_r@PAGE
    add x2, x2, _inv_min_p_mod_r@PAGEOFF
    ldr x2, [x2] // x1 = mu (actual value)

    bl _uint_mul3_64 // x0 = C * mu
    // mod r = 2^64 (Automatic as we will only load the lsb word value for the next step)

    // 3. C ← (C + p*q) /r

    // p * q
    add x0, sp, #128 // temp address
    adrp x1, _p@PAGE
    add x1, x1, _p@PAGEOFF
    ldr x2, [sp, #128] // load lsb word of temp (q)
    bl _uint_mul3_64_full // temp = p*q

    add x0, sp, #128 // temp addr
    add x1, sp, #64 // C address
    mov x2, x0 // x2 = temp
    bl _uint_add3 // temp = C + temp(p*q)

    // 4. C <- temp/r (we do this by just copieng over word 1-9, without 0)
    ldp x0, x1, [sp, #136] // temp addr + 8
    stp x0, x1, [sp, #64]
    ldp x0, x1, [sp, #152] // temp addr + 24
    stp x0, x1, [sp, #80]
    ldp x0, x1, [sp, #168] // temp addr + 40
    stp x0, x1, [sp, #96]
    ldp x0, x1, [sp, #184] // temp addr + 56
    stp x0, x1, [sp, #112]

    // 5. i <- i + 1
    ldr x5, [sp, #200] // load i
    ldr x6, [sp, #208] // load offset
    add x5, x5, #1 // i = i + 1
    add x6, x6, #8
    stp x5, x6, [sp, #200] // store i and offset

    // if i < 8 goto loop
    cmp x5, #8
    b.lt _fp_mul_loop

_finish_fp_mul:
    // if C >= p then C = C - p

    // load C into x3-x10
    ldp x3, x4, [sp, #64]
    ldp x5, x6, [sp, #80]
    ldp x7, x8, [sp, #96]
    ldp x9, x10, [sp, #112]

    // load p into x12-x20
    adrp x0, _p@PAGE
    add x0, x0, _p@PAGEOFF
    ldp x12, x13, [x0, #0]
    ldp x14, x15, [x0, #16]
    ldp x16, x17, [x0, #32]
    ldp x19, x20, [x0, #48]

     //Subtract Prime from C into register x3-x10, not(carry)
    SUBS x3, x3, x12
    SBCS x4, x4, x13
    SBCS x5, x5, x14
    SBCS x6, x6, x15
    SBCS x7, x7, x16
    SBCS x8, x8, x17
    SBCS x9, x9, x19
    SBCS x10, x10, x20
    SBC x21, xzr, xzr
    // The carry into x21

    // If the result of C - p was negative, the mask will be 1, otherwise 0
    and x12, x12, x21
    and x13, x13, x21
    and x14, x14, x21
    and x15, x15, x21
    and x16, x16, x21
    and x17, x17, x21
    and x19, x19, x21
    and x20, x20, x21

    // Add masked p to C - p (masked p = p | 0)
    ADDS x3, x3, x12
    ADCS x4, x4, x13
    ADCS x5, x5, x14
    ADCS x6, x6, x15
    ADCS x7, x7, x16
    ADCS x8, x8, x17
    ADCS x9, x9, x19
    ADC x10, x10, x20

    // Store result
    ldr x0, [sp, #8] //load result address C
    stp x3, x4, [x0, #0]
    stp x5, x6, [x0, #16]
    stp x7, x8, [x0, #32]
    stp x9, x10, [x0, #48]


    // restore register&stack
    ldp lr, x0, [sp, #0]
    ldp x1, x2, [sp, #16]
    ldp x17, x19, [sp, #32]
    ldp x20, x21, [sp, #48]

    add sp, sp, #224
    ret





/*
x0 = result (9 words)
x1 = A (8 Words) address
x2 = B uint64_t
 */
_uint_mul3_64_full:

    // First limb
    ldr x4, [x1, #0]   // load limb
    umulh x5, x4, x2   // high 
    mul x4, x4, x2     // low
    str x4, [x0, #0]

    // Second Limb
    ldr x7, [x1, #8]    // load limb
    mul x4, x7, x2      // low
    adds x4, x4, x5     // add past lower (x5)
    str x4, [x0, #8]
    umulh x5, x7, x2    // high

    // Third Limb
    ldr x7, [x1, #16]    // load limb
    mul x4, x7, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #16]
    umulh x5, x7, x2    // high

    // Fourth Limb
    ldr x7, [x1, #24]    // load limb
    mul x4, x7, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #24]
    umulh x5, x7, x2    // high

    // Limb Numero 5
    ldr x7, [x1, #32]    // load limb
    mul x4, x7, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #32]
    umulh x5, x7, x2    // high

    // Limb Numero 6
    ldr x7, [x1, #40]    // load limb
    mul x4, x7, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #40]
    umulh x5, x7, x2    // high

    // Limb Numero 7
    ldr x7, [x1, #48]    // load limb
    mul x4, x7, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #48]
    umulh x5, x7, x2    // high

    // Limb Numero 8
    ldr x7, [x1, #56]    // load limb
    mul x4, x7, x2      // low
    adcs x4, x4, x5     // add past lower (x5) now with carry flag as well
    str x4, [x0, #56]
    umulh x5, x7, x2    // high

    adc x5, x5, xzr    // add past lower (x5) now with carry flag as well
    str x5, [x0, #64]   // store last limb

    ret
