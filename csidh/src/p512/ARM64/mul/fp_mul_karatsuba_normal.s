.extern fp_mulsq_count

/*
This file contains the fp_mul3 method for montgomery reduction with first a subtractive karatsuba multiplication
of 256*256 -> 512 bits and then a reduction
 */
.macro LOAD_8_WORD_NUMBER42, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, num_pointer
    LDP \reg1, \reg2, [\num_pointer,#0] 
    LDP \reg3, \reg4, [\num_pointer,#16]
    LDP \reg5, \reg6, [\num_pointer,#32]
    LDP \reg7, \reg8, [\num_pointer, #48]
.endm

.macro STORE_8_WORD_NUMBER42, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, destination_pointer
    STP \reg1, \reg2, [\destination_pointer,#0] 
    STP \reg3, \reg4, [\destination_pointer,#16]
    STP \reg5, \reg6, [\destination_pointer,#32]
    STP \reg7, \reg8, [\destination_pointer, #48]
.endm

.macro LOAD_511_PRIME42, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8
    adrp \reg8, _p@PAGE
    add \reg8, \reg8, _p@PAGEOFF
    LDP \reg1, \reg2, [\reg8, #0]
    LDP \reg3, \reg4, [\reg8, #16]
    LDP \reg5, \reg6, [\reg8, #32]
    LDP \reg7, \reg8, [\reg8, #48]
   
.endm

.macro LOAD_8_WORD_NUMBER2, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, num_pointer
    LDP \reg1, \reg2, [\num_pointer,#0] 
    LDP \reg3, \reg4, [\num_pointer,#16]
    LDP \reg5, \reg6, [\num_pointer,#32]
    LDP \reg7, \reg8, [\num_pointer, #48]
.endm

.macro STORE_8_WORD_NUMBER2, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, destination_pointer
    STP \reg1, \reg2, [\destination_pointer,#0] 
    STP \reg3, \reg4, [\destination_pointer,#16]
    STP \reg5, \reg6, [\destination_pointer,#32]
    STP \reg7, \reg8, [\destination_pointer, #48]
.endm

.macro LOAD_511_PRIME, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8
    adrp \reg8, _p@PAGE
    add \reg8, \reg8, _p@PAGEOFF
    LDP \reg1, \reg2, [\reg8, #0]
    LDP \reg3, \reg4, [\reg8, #16]
    LDP \reg5, \reg6, [\reg8, #32]
    LDP \reg7, \reg8, [\reg8, #48]
   
.endm


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
    adc    \C7, \B0, xzr

.endm

/*
Montgomery multiplication
x0 = x1 * x2
void fp_mul3(fp *x, fp const *y, fp const *z)
*/
.global _fp_mul3
_fp_mul3:
    adrp x3, _fp_mul_counter@PAGE
    add x3, x3, _fp_mul_counter@PAGEOFF
    ldr x3, [x3]
    cbz x3, 0f
    ldr x4, [x3]
    add x4, x4, #1
    str x4, [x3]
    0:
    sub sp, sp, #224 // make space in the stack for 56 words
    stp lr, x0, [sp, #0] // store lr and result address
    stp x19, x20, [sp, #16] //store x19 and x20 to avoid segmentation fault
    stp x21, x22, [sp, #32] //store x21 and x22 to avoid segmentation fault

    mov x0, x2 // Move x2 to x0 for multiplication
    add x2, sp, #64 // result for mul = stack address + 16 + (16+8*16) words
    bl _uint_mul_512x512 // x2 = x0 * x1
    mov x0, x2 // copy result address of mul to x0 (this points to stack + 64)
    ldr x1, [sp, #8] // load back initial result address to x1
    bl _monte_reduce
    ldp lr, x0, [sp, #0] // get back lr
    ldp x19, x20, [sp, #16] //get back x19 - x22
    ldp x21, x22, [sp, #32]

    add sp, sp, #224 //give back the stack
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
    stp lr, x1, [sp, #0] // store lr and result address
    str x0, [sp, #16] // store adress of a

    // a mod R = Lower 8 words of a
    // load mu into x1 
    adrp x1, _mu@PAGE //get address of mu
    add x1, x1, _mu@PAGEOFF //add offset of mu
    //add  x1, x1, :lo12:mu aah, this was unnecessary then :) smart move
    add x2, sp, #24 // result of multiplication 16 words -> sp #24 - sp# 152
    // mu [x1] * ( a [x0] mod R )
    bl _uint_mul_512x512
    mov x1, x2 // copy result address to x1
    // q = lower 8 words of x1
    // C ← (a + p*q)/R
    // x0 = p
    adrp x0, _p@PAGE
    add x0, x0, _p@PAGEOFF
    add x2, sp, #152 // result of multiplication p*q 16 words from sp#152-280
    bl _uint_mul_512x512
    mov x0, x2 // x0 = p*q
    ldr x1, [sp, #16] // load address of a into x1 
    add x2, sp, #280 // result again 16 words from sp #280-408
    bl _add2_16_words
    // Result in higher 8 words of x2
    add x2, x2, #64 // 
    // If C >= p then C = C - p
    LOAD_8_WORD_NUMBER42 x3, x4, x5, x6, x7, x8, x9, x10, x2
    LOAD_511_PRIME42 x12, x13, x14, x15, x16, x17, x19, x20
    
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
    SBCS x21, xzr, xzr

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
    ADCS x10, x10, x20

    // load result address
    ldr x1, [sp, #8]
    STORE_8_WORD_NUMBER42 x3, x4, x5, x6, x7, x8, x9, x10, x1    
    ldr lr, [sp, #0]
    add sp, sp, #512
    ret


/*  
Operation: c[x2] = a[x0] + b[x1]
a, b, c = 16 words
not defined in fp.c
*/
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

.macro MUL128x128 A0, A1, B0, B1, C0, C1, C2, C3, T0
    ; Multiply the least significant words
    mul     \C0, \A0, \B0       ; C0 = A0 * B0 (low word)
    umulh   \C1, \A0, \B0       ; C1 = A0 * B0 (high word)

    ; Add the cross-product of lower A0:B1 
    mul     \T0, \A0, \B1       ; T0 = A0 * B1 (low word)
    adds    \C1, \C1, \T0       ; C1 += T1
    adcs     \C2, xzr, xzr       ; C2 = carry from previous addition
    ; Add the cross-prodoct of lower A1:B0
    mul     \T0, \A1, \B0       ; T1 = A1 * B0 (low word)
    adds    \C1, \C1, \T0       ; C1 += T1 (with carry)
    adcs     \C2, \C2, xzr       ; C2 += carry from previous addition    
    adcs    \C3, xzr, xzr      ; C3 = potential carry prop
    ; to the same for the highers into C2
    umulh   \T0, \A0, \B1       ; T0 = A0 * B1 (high word)
    adds    \C2, \T0, \C2       ; C2 = T0 + C2
    adcs     \C3, \C3, xzr       ; C3 = carry from previous addition
    umulh   \T0, \A1, \B0       ; T0 = A1 * B0 (high word)
    adds    \C2, \C2, \T0       ; C2 += T0 
    adcs     \C3, \C3, xzr       ; C3 += carry from previous addition
    ; Multiply the most significant words
    mul     \T0, \A1, \B1
    adds    \C2, \C2, \T0
    adcs     \C3, \C3, xzr
    umulh   \T0, \A1, \B1
    adcs     \C3, \C3, \T0
.endm



// not using x18 and x29 as apple states -> x3-x17, x19-x28 = 15 + 10 = 25 registers
.global _uint_mul_512x512
_uint_mul_512x512:
   // add more space to the stack
    sub     sp, sp, #320
    // 176-192 :: x18
    // 192-208 :: backup for x18
    // 208-224 :: x29
    // 224-240 :: backup for x29
    // 240-256 :: backup for x8
    // 256-272 :: carry flag
    // 272-288 :: backup for x19
    // 288-304 :: combined carry
    // 304-320 :: safe heaven for combined carry
    stp lr, x19, [sp,#96]
    stp x20, x21, [sp,#112]
    stp x22, x23, [sp,#128]
    str x24, [sp,#144]

    //LOAD A
    ldp     x3, x4, [x0]
    ldp     x5, x6, [x0,#16]
    ldp     x7, x8, [x0,#32]
    ldp     x9, x10, [x0,#48]

    // save x25-x28 for some reason
    stp     x25, x26, [sp,#48]
    stp     x27, x28, [sp,#64]
    str     x29, [sp, #80]
    //str    x29, [sp, #208]

    // x26-x29 <- AH + AL, x7 <- mask
    adds    x26, x3, x7
    ldp     x11, x12, [x1,#0]
    adcs    x27, x4, x8
    ldp     x13, x14, [x1,#16]
    adcs    x28, x5, x9
    ldp     x15, x16, [x1,#32]
    //change x29 start
    str     x0, [sp,#224]
    ldr     x0, [sp,#208]
    adcs    x0, x6, x10
    str     x0, [sp,#208]
    ldr     x0, [sp,#224]
    // change x29 end
    // change x18 start
    str     x0, [sp,#192]
    ldp     x17, x0, [x1,#48]
    str     x0, [sp,#176]
    ldr     x0, [sp,#192]
    //change x18 end
    adc     x7, xzr, xzr

    // For some reason store x19 and x20 in stack
    stp     x19, x20, [sp,#0]

    // x11-x14 <- BH + BL, x8 <- mask
    adds    x11, x11, x15
    stp     x21, x22, [sp,#16]
    adcs    x12, x12, x16
    stp     x23, x24, [sp,#32]
    adcs    x13, x13, x17
    // change x18 start
    str     x0, [sp,#192]
    ldr     x0, [sp,#176]
    adcs    x14, x14, x0
    str     x0, [sp,#176]
    ldr     x0, [sp,#192]
    //change x18 end
    adc     x8, xzr, xzr
    
    // x15-x18 <- masked (BH + BL)
    sub     x9, xzr, x7
    sub     x10, xzr, x8
    and     x15, x11, x9
    and     x16, x12, x9
    and     x17, x13, x9
    //change x18 start
    str     x0, [sp,#192]
    ldr     x0, [sp,#176]
    and     x0, x14, x9
    str     x0, [sp,#176]
    ldr     x0, [sp,#192]
    //change x18 end

    // x19-x22 <- masked (AH + AL)
    and     x19, x26, x10
    and     x20, x27, x10
    and     x21, x28, x10
    //change x29 start
    str     x0, [sp,#224]
    ldr     x0, [sp,#208]
    and     x22, x0, x10
    str     x0, [sp,#208]
    ldr     x0, [sp,#224]
    //change x29 end

    // x15-x18 <- masked (AH+AL) + masked (BH+BL), step 1
    adds    x15, x15, x19
    adcs    x16, x16, x20
    adcs    x17, x17, x21
    stp     x26, x27, [x2,#0] //those two values are used for the Karatsuba later
    // change x18 start
    str     x0, [sp,#192]
    ldr     x0, [sp,#176]
    // update carry start
    str     x9, [sp,#272]
    // a carry can occur, if both operants have a carry
    and     x9, x7, x8
    // a carry can also occur, if the result of the masked addition has a carry
    adcs     x0, x0, x22
    adc     x9, x9, xzr
    str     x9, [sp,#256]
    ldr     x9, [sp,#272]
    // update carry end
    str     x0, [sp,#176]
    ldr     x0, [sp,#192]
    //change x18 end
    //change x29 start
    str     x0, [sp,#224]
    ldr     x0, [sp,#208]
    
    // x8-x10,x19-x23 <- (AH+AL) x (BH+BL), low part
    MUL256_KARATSUBA_COMBA  x2, x26, x27, x28, x0, x11, x12, x13, x14, x8, x9, x10, x19, x20, x21, x22, x23, x24, x25  

    str     x0, [sp,#208]
    ldr     x0, [sp,#224]
    //change x29 end

    // x15-x18 <- (AH+AL) x (BH+BL), final step
    adds    x15, x15, x20
    ldp     x11, x12, [x1,#0]
    adcs    x16, x16, x21
    adcs    x17, x17, x22
    ldp     x13, x14, [x1,#16]
    //change x18 start
    str     x0, [sp,#192]
    ldr     x0, [sp,#176]
    adcs     x0, x0, x23
     // update carry start
    str     x9, [sp,#272]
    ldr     x9, [sp,#256]
    // a carry can occur, if the addition of the upper part has a carry
    adc     x9, x9, xzr
    str     x9, [sp,#256]
    ldr     x9, [sp,#272]
    // update carry end
    str     x0, [sp,#176]
    ldr     x0, [sp,#192]
    //change x18 end
    // change x29 start
    str    x1, [sp,#224]
    ldr    x1, [sp,#208]
    // x20-x27 <- AL x BL
    MUL256_KARATSUBA_COMBA  x0, x3, x4, x5, x6, x11, x12, x13, x14, x20, x21, x22, x23, x24, x25, x26, x27, x28, x1

   str   x1, [sp,#208]
   ldr  x1, [sp,#224]
    //change x29 end

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
    stp     x20, x21, [x2] //here they overwrite x2 withouth using the values x26 and x27
    sbcs    x16, x16, x25
    stp     x22, x23, [x2,#16]
    sbcs    x17, x17, x26
    stp     x24, x25, [x2,#32]
    //change x18 start
    str     x0, [sp,#192]
    ldr     x0, [sp,#176]
    sbcs     x0, x0, x27
    // update carry start
    str     x9, [sp,#272]
    ldr     x9, [sp,#256]
    // the subtraction of the upper part can "use" the carry
    sbc     x9, x9, xzr
    str     x9, [sp,#256]
    ldr     x9, [sp,#272]
    // update carry end
    str    x0, [sp,#176]
    ldr   x0, [sp,#192]
    //change x18 end

    // x20-x25, x1, x7 <- AH x BH
    add     x0, x0, #32

    //change x29 start
    str     x8, [sp,#240]
    ldr     x8, [sp,#208]

    MUL256_KARATSUBA_COMBA  x0, x3, x4, x5, x6, x11, x12, x13, x14, x20, x21, x22, x23, x24, x25, x1, x7, x28, x8
    
    str     x8, [sp,#208]
    ldr     x8, [sp,#240]
    //change x29 end

    // x8-x10, x19, x15-x18 <- (AH+AL) x (BH+BL) - ALxBL - AHxBH
    subs    x8, x8, x20 
    sbcs    x9, x9, x21
    ldp     x3, x4, [x2,#32]
    sbcs    x10, x10, x22
    sbcs    x19, x19, x23
    // change x29 start
    str     x0, [sp,#224]
    ldr     x0, [sp,#208]
    ldr     x0, [sp,#80]
    str     x0, [sp,#208]
    ldr     x0, [sp,#224]
    //change x29 end
    sbcs    x15, x15, x24
    sbcs    x16, x16, x25
    sbcs    x17, x17, x1
    // change x18 start
    str     x0, [sp,#192]
    ldr     x0, [sp,#176]
    sbcs     x0, x0, x7
    // update carry start
    str     x9, [sp,#272]
    ldr     x9, [sp,#256]
    // the subtraction of the upper part can "use" the carry
    sbc     x9, x9, xzr
    str     x9, [sp,#256]
    ldr     x9, [sp,#272]
    // update carry end
    str    x0, [sp,#176]
    ldr  x0, [sp,#192]
    //change x18 end

    //here now we should have step_4 correctly in (from highest to lowest) x0, x17, x16, x15, x19, x10, x9, x8
    // so step_5: step_2 + half_padded step_4 + full_padded step_1
    // step_4 is in x8, x9, x10,x19, x15, x16, x17, x18 --> numbers correct, but carry is there
    // step_1 is in x25 - x20 and x1 and x7 --> correct
    // step_2 is in partly in x2 --> correct
    // this is why the first 4 words are already correctly loaded in x2 (foxes)  --> check, those are the same values
    adds    x8, x8, x3 //still in register fifth word of step 2
    adcs    x9, x9, x4 // still in register sixth word of step 2
    stp     x8, x9, [x2,#32]
    adcs    x10, x10, x26 // still in register seventh word of step 2
    adcs    x19, x19, x27 // still in register eight word of step 2
    stp     x10, x19, [x2,#48]    
    adcs    x15, x15, x20 
    ldp     x19, x20, [sp,#0]  
    ldp     x27, x28, [sp,#64]   
    adcs    x16, x16, x21
    stp     x15, x16, [x2,#64]
    adcs    x17, x17, x22
    ldp     x21, x22, [sp,#16]
    // change x18 start
    str    x0, [sp,#192]
    ldr   x0, [sp,#176]
    adcs    x0, x0, x23
    stp     x17, x0, [x2,#80] 
    str   x0, [sp,#176]
    ldr   x0, [sp,#192]
    adcs    x24, x24, xzr
    //update carry start
    str x19, [sp,#272]
    ldr x19, [sp,#256]
    //problem, what if the carry is negative?
    adcs x24, x24, x19
    str x19, [sp,#256]
    ldr x19, [sp,#272]
    //udpate carry end
    adcs    x25, x25, xzr //only change
    stp     x24, x25, [x2,#96] 
    //from here, x18 does not seem to be a problem
    ldp     x23, x24, [sp,#32]
    adcs    x1, x1, xzr
    ldp     x25, x26, [sp,#48]
    adc     x7, x7, xzr
    stp     x1, x7,   [x2,#112]    
    
    ldp lr, x19, [sp,#96]
    ldp x20, x21, [sp,#112]
    ldp x22, x23, [sp,#128]
    ldr x24, [sp,#144]
    ldr x29, [sp,#80]

    add sp, sp, #320
    ret
