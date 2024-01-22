.extern _fp_mul_counter
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

/////////////////////////////////////////////////MACRO
/*
C --> LIMB to be calculated on
M --> multiplier LIMBS
A --> registers for storing the new results
B --> registers with the old results
 */

.macro  SCHOOLBOOK_STEP_512 C0,M0,M1,M2,M3,M4,M5,M6,M7,A0,A1,A2,A3,A4,A5,A6,A7,A8,B0,B1,B2,B3,B4,B5,B6,B7
    // carry from previous step always in B0
    mul     \A0, \M0, \C0 // lower part
    adds    \A0, \A0, \B0 
    umulh   \A1, \M0, \C0 // upper part
    // 2/9 in x12
    mul     \A2, \M1, \C0 // lower part
    adcs    \A2, \A2, \B1 //has carry from previous step included
    adcs    \B0, xzr, xzr // carry for the next step
    adds    \A1, \A2, \A1 // from previous results
    adcs    \B0, \B0, xzr // carry for the next step
    umulh   \A2, \M1, \C0 // upper part
    // 3/9in x13
    mul     \A3, \M2, \C0
    adds    \A3, \A3, \B0 //add carry from previous step
    adcs    \B0, xzr, xzr // carry for the next step
    adds    \A3, \A3, \B2
    adcs    \B0, \B0, xzr // carry for the next step
    adds    \A2, \A3, \A2 // lower part
    adcs    \B0, \B0, xzr // carry for the next step
    umulh   \A3, \M2, \C0 // upper part
    // 4/9 in x14
    mul     \A4, \M3, \C0
    adds    \A4, \A4, \B0 //add carry from previous step
    adcs    \B0, xzr, xzr // carry for the next step
    adds    \A4, \A4, \B3
    adcs    \B0, \B0, xzr // carry for the next step
    adds    \A3, \A4, \A3 // lower part
    adcs    \B0, \B0, xzr // carry for the next step
    umulh   \A4, \M3, \C0 // upper part
    // 5/9 in x15
    mul     \A5, \M4, \C0
    adds    \A5, \A5, \B0 //add carry from previous step
    adcs    \B0, xzr, xzr // carry for the next step
    adds    \A5, \A5, \B4
    adcs    \B0, \B0, xzr // carry for the next step
    adds    \A4, \A5, \A4 // lower part
    adcs    \B0, \B0, xzr // carry for the next step
    umulh   \A5, \M4, \C0 // upper part
    // 6/9 in x16
    mul     \A6, \M5, \C0
    adds    \A6, \A6, \B0 //add carry from previous step
    adcs    \B0, xzr, xzr // carry for the next step
    adds    \A6, \A6, \B5
    adcs    \B0, \B0, xzr // carry for the next step
    adds    \A5, \A6, \A5 // lower part
    adcs    \B0, \B0, xzr // carry for the next step
    umulh   \A6, \M5, \C0 // upper part
    // 7/9 in x17
    mul     \A7, \M6, \C0
    adds    \A7, \A7, \B0 //add carry from previous step
    adcs    \B0, xzr, xzr // carry for the next step
    adds    \A7, \A7, \B6
    adcs    \B0, \B0, xzr // carry for the next step
    adds    \A6, \A7, \A6 // lower part
    adcs    \B0, \B0, xzr // carry for the next step
    umulh   \A7, \M6, \C0 // upper part
    // 8/9 in x19
    mul     \A8, \M7, \C0
    adds    \A8, \A8, \B0 //add carry from previous step
    adcs    \B0, xzr, xzr // carry for the next step
    adds    \A8, \A8, \B7
    adcs    \B0, \B0, xzr // carry for the next step
    adds    \A7, \A8, \A7 // lower part
    adcs    \B0, \B0, xzr // carry for the next step
    umulh   \A8, \M7, \C0 // upper part
    // 9/9 in x20
    add    \A8, \A8, xzr // carry of multiplication
    adds    \A8, \A8, \B0 //add carry from previous step


.endm

/*
schoolbook multiplication of 512x512 bit numbers
c [x2] = a [x0] * b [x1]
 */
.global _uint_mul_512x512
_uint_mul_512x512:
    // Input parameters:
    // x: address of the first 512-bit number
    // y: address of the second 512-bit number
    // result: address of the result buffer
    sub     sp, sp, #96
    stp     lr, x19, [sp,#0]
    stp     x20, x21, [sp,#16]
    stp     x22, x23, [sp,#32]
    stp     x25, x26, [sp,#48]
    stp     x27, x28, [sp,#64]
    stp     x24, x29, [sp,#80]

    // x3-x10 A registers
    ldp     x3, x4, [x0]
    ldp     x5, x6, [x0,#16]
    ldp     x7, x8, [x0,#32]
    ldp     x9, x10, [x0,#48]

    //x11-x17, x19-x20  for the first iteration
    ldr     x0, [x1, #0]
    // 1/9 in x20 --> just that it is nice to continue with the macros later
    mul     x20, x3, x0 // lower part
    umulh   x11, x3, x0 // upper part
    // 2/9 in x11
    mul     x12, x4, x0 // lower part
    adds    x11, x12, x11//add the carry from previous step
    umulh   x12, x4, x0 // upper part
    // 3/9in x12
    mul     x13, x5, x0
    adcs    x12, x13, x12 // lower part
    umulh   x13, x5, x0 // upper part
    // 4/9 in x13
    mul     x14, x6, x0
    adcs    x13, x14, x13 // lower part
    umulh   x14, x6, x0 // upper part
    // 5/9 in x14
    mul     x15, x7, x0
    adcs    x14, x15, x14 // lower part
    umulh   x15, x7, x0 // upper part
    // 6/9 in x15
    mul     x16, x8, x0
    adcs    x15, x16, x15 // lower part
    umulh   x16, x8, x0 // upper part
    // 7/9 in x16
    mul     x17, x9, x0
    adcs    x16, x17, x16 // lower part
    umulh   x17, x9, x0 // upper part
    // 8/9 in x17
    mul     x19, x10, x0
    adcs    x17, x19, x17 // lower part
    umulh   x19, x10, x0 // upper part
    // 9/9 in x19
    adcs    x19, x19, xzr // carry of multiplication
    //store the first result
    str     x20, [x2,#0]
   //what if this operation has a carry 

    ldr     x0, [x1, #8]
    // remark Jan: I can use x29 here, because the result will always be a valid frame record (The frame pointer register (FP, X29) must always address a valid frame record.
    SCHOOLBOOK_STEP_512 x0, x3, x4, x5, x6, x7, x8, x9, x10, x21, x22, x23, x24, x25, x26, x27, x28, x29, x11, x12, x13, x14, x15, x16, x17, x19
    // now we can take the lowest limb and store it, because nothing more will come
    str     x21, [x2, #8]
    // new base results now in x22-x29, freely available regsiters x11-x20
    ldr     x0, [x1, #16]
    SCHOOLBOOK_STEP_512 x0,x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17,x19, x20, x22, x23, x24, x25, x26, x27, x28, x29
    str     x11, [x2, #16]
    ldr     x0, [x1, #24]
    SCHOOLBOOK_STEP_512 x0,x3, x4, x5, x6, x7, x8, x9, x10, x21, x22, x23, x24, x25, x26, x27, x28, x29, x12, x13, x14, x15, x16, x17, x19, x20
    str     x21, [x2, #24]
    ldr     x0, [x1, #32]
    SCHOOLBOOK_STEP_512 x0,x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17,x19, x20, x22, x23, x24, x25, x26, x27, x28, x29
    str     x11, [x2, #32]
    ldr     x0, [x1, #40]
    SCHOOLBOOK_STEP_512 x0,x3, x4, x5, x6, x7, x8, x9, x10, x21, x22, x23, x24, x25, x26, x27, x28, x29, x12, x13, x14, x15, x16, x17, x19, x20
    str     x21, [x2, #40]
    ldr     x0, [x1, #48]
    SCHOOLBOOK_STEP_512 x0,x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17,x19, x20, x22, x23, x24, x25, x26, x27, x28, x29
    str     x11, [x2, #48]
    ldr     x0, [x1, #56]
    SCHOOLBOOK_STEP_512 x0,x3, x4, x5, x6, x7, x8, x9, x10, x21, x22, x23, x24, x25, x26, x27, x28, x29, x12, x13, x14, x15, x16, x17, x19, x20
    str     x21, [x2, #56]
    //8 limbs over, now we have the result in x21-x29 which are final, since no multiplication will happen anymore
    stp     x22, x23, [x2, #64]
    stp     x24, x25, [x2, #80]
    stp     x26, x27, [x2, #96]
    stp     x28, x29, [x2, #112]


    ldp     lr, x19, [sp,#0]
    ldp     x20, x21, [sp,#16]
    ldp     x22, x23, [sp,#32]
    ldp     x25, x26, [sp,#48]
    ldp     x27, x28, [sp,#64]
    ldp     x24, x29, [sp,#80]

    add     sp,sp, #96

    ret
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
