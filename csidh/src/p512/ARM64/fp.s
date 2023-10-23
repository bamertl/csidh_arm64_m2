.extern r_squared_mod_p


//////////////////////////////////////////// MACRO
.macro MUL128_COMBA_CUT  A0, A1, B0, B1, C0, C1, C2, C3, T0
    mul     \A0, \A1, \B0
    umulh   \B0, \A1, \B0
    adds    \C1, \C1, \C3
    adc     \C2, \C2, xzr
    
    mul     \T0, \A1, \B1
    umulh   \B1, \A1, \B1
    adds    \C1, \C1, \A0
    adcs    \C2, \C2, \B0
    adc     \C3, xzr, xzr
    
    adds    \C2, \C2, \T0
    adc     \C3, \C3, \B1
.endm


//////////////////////////////////////////// MACRO
.macro    MUL256_KARATSUBA_COMBA  M,A0,A1,A2,A3,B0,B1,B2,B3,C0,C1,C2,C3,C4,C5,C6,C7,T0,T1

    // A0-A1 <- AH + AL, T0 <- mask
    adds    \A0, \A0, \A2
    adcs    \A1, \A1, \A3
    adc     \T0, xzr, xzr

    // C6, T1 <- BH + BL, C7 <- mask
    adds    \C6, \B0, \B2
    adcs    \T1, \B1, \B3
    adc     \C7, xzr, xzr
    
    // C0-C1 <- masked (BH + BL)
    sub     \C2, xzr, \T0
    sub     \C3, xzr, \C7
    and     \C0, \C6, \C2
    and     \C1, \T1, \C2

    // C4-C5 <- masked (AH + AL), T0 <- combined carry
    and     \C4, \A0, \C3
    and     \C5, \A1, \C3
    mul     \C2, \A0, \C6
    mul     \C3, \A0, \T1
    and     \T0, \T0, \C7

    // C0-C1, T0 <- (AH+AL) x (BH+BL), part 1
    adds    \C0, \C4, \C0
    umulh   \C4, \A0, \T1    
    adcs    \C1, \C5, \C1
    umulh   \C5, \A0, \C6
    adc     \T0, \T0, xzr

    // C2-C5 <- (AH+AL) x (BH+BL), low part
    MUL128_COMBA_CUT  \A0, \A1, \C6, \T1, \C2, \C3, \C4, \C5, \C7
    ldp     \A0, \A1, [\M,#0]
    
    // C2-C5, T0 <- (AH+AL) x (BH+BL), final part
    adds    \C4, \C0, \C4
    umulh   \C7, \A0, \B0 
    umulh   \T1, \A0, \B1 
    adcs    \C5, \C1, \C5
    mul     \C0, \A0, \B0
    mul     \C1, \A0, \B1  
    adc     \T0, \T0, xzr

    // C0-C1, T1, C7 <- AL x BL
    MUL128_COMBA_CUT  \A0, \A1, \B0, \B1, \C0, \C1, \T1, \C7, \C6
    
    // C2-C5, T0 <- (AH+AL) x (BH+BL) - ALxBL
    mul     \A0, \A2, \B2
    umulh   \B0, \A2, \B2
    subs    \C2, \C2, \C0 
    sbcs    \C3, \C3, \C1
    sbcs    \C4, \C4, \T1
    mul     \A1, \A2, \B3
    umulh   \C6, \A2, \B3   
    sbcs    \C5, \C5, \C7
    sbc     \T0, \T0, xzr

    // A0, A1, C6, B0 <- AH x BH 
    MUL128_COMBA_CUT  \A2, \A3, \B2, \B3, \A0, \A1, \C6, \B0, \B1
    
    // C2-C5, T0 <- (AH+AL) x (BH+BL) - ALxBL - AHxBH
    subs    \C2, \C2, \A0 
    sbcs    \C3, \C3, \A1
    sbcs    \C4, \C4, \C6
    sbcs    \C5, \C5, \B0
    sbc     \T0, \T0, xzr
    
    adds    \C2, \C2, \T1 
    adcs    \C3, \C3, \C7
    adcs    \C4, \C4, \A0
    adcs    \C5, \C5, \A1
    adcs    \C6, \T0, \C6
    adc     \C7, \B0, xzr
.endm

/* 
mul a la https://github.com/microsoft/PQCrypto-SIDH/blob/master/src/P503/ARM64/fp_arm64_asm.S
//  Operation: c [x2] = a [x0] * b [x1]
a = 8 words, b = 8 words, c = 16 words
*/
_mul:
    sub     sp, sp, #96

    //LOAD A
    ldp     x3, x4, [x0]
    ldp     x5, x6, [x0,#16]
    ldp     x7, x8, [x0,#32]
    ldp     x9, x10, [x0,#48]

    // save x25-x28 for some reason
    stp     x25, x26, [sp,#48]
    stp     x27, x28, [sp,#64]
    str     x29, [sp, #80]

    // x26-x29 <- AH + AL, x7 <- mask
    adds    x26, x3, x7
    ldp     x11, x12, [x1,#0]
    adcs    x27, x4, x8
    ldp     x13, x14, [x1,#16]
    adcs    x28, x5, x9
    ldp     x15, x16, [x1,#32]
    adcs    x29, x6, x10
    ldp     x17, x18, [x1,#48]
    adc     x7, xzr, xzr

    // For some reason store x19 and x20 in stack
    stp     x19, x20, [sp,#0]

    // x11-x14 <- BH + BL, x8 <- mask
    adds    x11, x11, x15
    stp     x21, x22, [sp,#16]
    adcs    x12, x12, x16
    stp     x23, x24, [sp,#32]
    adcs    x13, x13, x17
    adcs    x14, x14, x18
    adc     x8, xzr, xzr
    
    // x15-x18 <- masked (BH + BL)
    sub     x9, xzr, x7
    sub     x10, xzr, x8
    and     x15, x11, x9
    and     x16, x12, x9
    and     x17, x13, x9
    and     x18, x14, x9

    // x19-x22 <- masked (AH + AL)
    and     x19, x26, x10
    and     x20, x27, x10
    and     x21, x28, x10
    and     x22, x29, x10

    // x15-x18 <- masked (AH+AL) + masked (BH+BL), step 1
    adds    x15, x15, x19
    adcs    x16, x16, x20
    adcs    x17, x17, x21
    stp     x26, x27, [x2,#0]
    adc     x18, x18, x22
    
    // x8-x10,x19-x23 <- (AH+AL) x (BH+BL), low part
    MUL256_KARATSUBA_COMBA  x2, x26, x27, x28, x29, x11, x12, x13, x14, x8, x9, x10, x19, x20, x21, x22, x23, x24, x25  
    
    // x15-x18 <- (AH+AL) x (BH+BL), final step
    adds    x15, x15, x20
    ldp     x11, x12, [x1,#0]
    adcs    x16, x16, x21
    adcs    x17, x17, x22
    ldp     x13, x14, [x1,#16]
    adc     x18, x18, x23

    // x20-x27 <- AL x BL
    MUL256_KARATSUBA_COMBA  x0, x3, x4, x5, x6, x11, x12, x13, x14, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29
    
    // x8-x10, x19, x15-x18 <- (AH+AL) x (BH+BL) - ALxBL
    subs    x8, x8, x20 
    ldp     x3, x4, [x0,#32]
    sbcs    x9, x9, x21
    ldp     x5, x6, [x0,#48]
    sbcs    x10, x10, x22
    ldp     x11, x12, [x1,#32]
    sbcs    x19, x19, x23
    ldp     x13, x14, [x1,#48]
    sbcs    x15, x15, x24
    stp     x20, x21, [x2]
    sbcs    x16, x16, x25
    stp     x22, x23, [x2,#16]
    sbcs    x17, x17, x26
    stp     x24, x25, [x2,#32]
    sbc     x18, x18, x27


    // x20-x25, x1, x7 <- AH x BH
    add     x0, x0, #32
    MUL256_KARATSUBA_COMBA  x0, x3, x4, x5, x6, x11, x12, x13, x14, x20, x21, x22, x23, x24, x25, x1, x7, x28, x29
    
    // x8-x10, x19, x15-x18 <- (AH+AL) x (BH+BL) - ALxBL - AHxBH
    subs    x8, x8, x20 
    sbcs    x9, x9, x21
    ldp     x3, x4, [x2,#32]
    sbcs    x10, x10, x22
    sbcs    x19, x19, x23
    ldr     x29, [sp,#80]
    sbcs    x15, x15, x24
    sbcs    x16, x16, x25
    sbcs    x17, x17, x1
    sbc     x18, x18, x7
    
    adds    x8, x8, x3 
    adcs    x9, x9, x4
    stp     x8, x9, [x2,#32]
    adcs    x10, x10, x26
    adcs    x19, x19, x27
    stp     x10, x19, [x2,#48]    
    adcs    x15, x15, x20 
    ldp     x19, x20, [sp,#0]  
    ldp     x27, x28, [sp,#64]   
    adcs    x16, x16, x21
    stp     x15, x16, [x2,#64]
    adcs    x17, x17, x22
    ldp     x21, x22, [sp,#16]
    adcs    x18, x18, x23
    stp     x17, x18, [x2,#80] 
    adcs    x24, x24, xzr
    stp     x24, x25, [x2,#96] 
    adcs    x25, x25, xzr
    ldp     x23, x24, [sp,#32]
    adcs    x1, x1, xzr
    ldp     x25, x26, [sp,#48]
    adc     x7, x7, xzr
    stp     x1, x7,   [x2,#112]    
    
    add     sp, sp, #96
    ret


/* x0 = x0 == x1 */
.global _fp_eq
_fp_eq:
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
x0 = destination
x1 = 1 limb number
 */
.global _fp_set
_fp_set:
    bl _uint_set


/*
x0 = fp destination
x1 = uint to encode to montgommery
to encode just monte mul with r_squared_mod_p
 */
.global _fp_enc
_fp_enc:
    adrp x2, r_squared_mod_p   ; Load the page address of r_squared_mod_p into x2, maybe have to add @PAGE
    add  x2, x2, :lo12:r_squared_mod_p ; Add the offset within that page to get the full address
    bl _fp_mul3
    ret



/*
Mongommery multiplication
x0 = x1 * x2
 */
.global _fp_mul3
_fp_mul3:
    sub sp, sp, #224 // 
    str lr, [sp, #0] // store lr
    str x0, [sp, #8] // store result address
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]

    mov x0, x2 // Move x2 to x0 for multiplication
    add x2, sp, #64 // result for mul = stack address + 16 + (16+8*16) words
    bl _mul // x2 = x0 * x1
    mov x0, x2 // copy result address of mul to x0 (this points to stack + 16)
    ldr x1, [sp, #8] // load back initial result address to x1
    bl _monte_reduce
    ldr lr, [sp, #0] // get back lr
    ldp x19, x20, [sp, #16]
    ldp x21, x22, [sp, #32]
    add sp, sp, #224

    ret

/*
Input: 
    a such that 0 <= a < p^2
    R = 2^256
    mu_big = -p^(-1) mod R
Output: 
    C ≡ a*R^(−1) mod p such that 0 ≤ C < p
    Operation: c[x1] = a [x0] mod p
 */
_monte_reduce:
    // Make place in the stack for
    sub sp, sp, #512
    str lr, [sp, #0] // store lr 
    str x1, [sp, #8] // store result address
    str x0, [sp, #16] // store adress of a

    // a mod R = Lower 8 words of a
    // load mu into x1 
    adrp x1, mu@PAGE
    //add  x1, x1, :lo12:mu
    add x2, sp, #24 // result of multiplication 16 words -> sp #24 - sp# 152
    // mu [x1] * ( a [x0] mod R )
    bl mul
    mov x1, x2 // copy result address to x1
    // q = lower 8 words of x1
    // C ← (a + p*q)/R
    // x0 = p
    adrp x0, p511@PAGE
    //add  x0, x0, :lo12:p511
    add x2, sp, #152 // result of multiplication p*q 16 words from sp#152-280
    bl mul
    mov x0, x2 // x0 = p*q
    ldr x1, [sp, #16] // load address of a into x1 
    add x2, sp, #280 // result again 16 words from sp #280-408
    bl _add2_16_words
    // Result in higher 8 words of x2
    add x2, x2, #64 // 
    // If C >= p then C = C - p
    LOAD_8_WORD_NUMBER x3, x4, x5, x6, x7, x8, x9, x10, x2
    LOAD_511_PRIME x12, x13, x14, x15, x16, x17, x19, x20

    
     //Subtract Prime from a + b into register x3-x11, not(carry)
    SUBS x3, x3, x12
    SBCS x4, x4, x13
    SBCS x5, x5, x14
    SBCS x6, x6, x15
    SBCS x7, x7, x16
    SBCS x8, x8, x17
    SBCS x9, x9, x19
    SBCS x10, x10, x20
    //SBCS x11, x11, xzr // this is the error.
    // The carry into x21
    SBC x21, xzr, xzr

    // If the result of a + b - p was negative, the mask will be 1, otherwise 0
    and x12, x12, x21
    and x13, x13, x21
    and x14, x14, x21
    and x15, x15, x21
    and x16, x16, x21
    and x17, x17, x21
    and x19, x19, x21
    and x20, x20, x21

    // Add masked p to a + b - p (masked p = p | 0)
    ADDS x3, x3, x12
    ADCS x4, x4, x13
    ADCS x5, x5, x14
    ADCS x6, x6, x15
    ADCS x7, x7, x16
    ADCS x8, x8, x17
    ADCS x9, x9, x19
    ADC x10, x10, x20


    // load result address
    ldr x1, [sp, #8]
    STORE_8_WORD_NUMBER x3, x4, x5, x6, x7, x8, x9, x10, x1    
    ldr lr, [sp, #0]
    add sp, sp, #512
    ret

    // Operation: c[x2] = a[x0] + b[x1]
// a, b, c = 16 words
_add2_16_words:
    // Word 0
    LDR x4, [x0]          // Load word 0 from a
    LDR x5, [x1]          // Load word 0 from b
    ADDS x6, x4, x5       // Add the two words, set flags
    STR x6, [x2]          // Store the result word 0 to c

    // Word 1
    LDR x4, [x0, #8]      
    LDR x5, [x1, #8]      
    ADCS x6, x4, x5       
    STR x6, [x2, #8]      
    
    // Word 2
    LDR x4, [x0, #16]     
    LDR x5, [x1, #16]     
    ADCS x6, x4, x5       
    STR x6, [x2, #16]

    // Word 3
    LDR x4, [x0, #24]
    LDR x5, [x1, #24]
    ADCS x6, x4, x5
    STR x6, [x2, #24]

    // Word 4
    LDR x4, [x0, #32]
    LDR x5, [x1, #32]
    ADCS x6, x4, x5
    STR x6, [x2, #32]

    // Word 5
    LDR x4, [x0, #40]
    LDR x5, [x1, #40]
    ADCS x6, x4, x5
    STR x6, [x2, #40]

    // Word 6
    LDR x4, [x0, #48]
    LDR x5, [x1, #48]
    ADCS x6, x4, x5
    STR x6, [x2, #48]

    // Word 7
    LDR x4, [x0, #56]
    LDR x5, [x1, #56]
    ADCS x6, x4, x5
    STR x6, [x2, #56]

    // Word 8
    LDR x4, [x0, #64]
    LDR x5, [x1, #64]
    ADCS x6, x4, x5
    STR x6, [x2, #64]

    // Word 9
    LDR x4, [x0, #72]
    LDR x5, [x1, #72]
    ADCS x6, x4, x5
    STR x6, [x2, #72]

    // Word 10
    LDR x4, [x0, #80]
    LDR x5, [x1, #80]
    ADCS x6, x4, x5
    STR x6, [x2, #80]

    // Word 11
    LDR x4, [x0, #88]
    LDR x5, [x1, #88]
    ADCS x6, x4, x5
    STR x6, [x2, #88]

    // Word 12
    LDR x4, [x0, #96]
    LDR x5, [x1, #96]
    ADCS x6, x4, x5
    STR x6, [x2, #96]

    // Word 13
    LDR x4, [x0, #104]
    LDR x5, [x1, #104]
    ADCS x6, x4, x5
    STR x6, [x2, #104]

    // Word 14
    LDR x4, [x0, #112]
    LDR x5, [x1, #112]
    ADCS x6, x4, x5
    STR x6, [x2, #112]

    // Word 15
    LDR x4, [x0, #120]
    LDR x5, [x1, #120]
    ADCS x6, x4, x5
    STR x6, [x2, #120]
    ret