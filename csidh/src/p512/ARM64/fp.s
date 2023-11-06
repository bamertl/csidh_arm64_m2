.extern _r_squared_mod_p
.extern _p_minus_2
.extern _uint_1
.extern _p_minus_1_halves
.extern _p
.extern _fp_1
.extern _mu
.extern _fp_mul3


.macro COPY_8_WORD_NUMBER, num1, num2, reg1, reg2
    LDP \reg1, \reg2, [\num1,#0] 
    STP \reg1, \reg2, [\num2,#0] 
    LDP \reg1, \reg2, [\num1,#16]
    STP \reg1, \reg2, [\num2,#16]
    LDP \reg1, \reg2, [\num1,#32]
    STP \reg1, \reg2, [\num2,#32]
    LDP \reg1, \reg2, [\num1,#48]
    STP \reg1, \reg2, [\num2,#48]
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

.macro MUL128x128 A0, A1, B0, B1, C0, C1, C2, C3, T0
    ; Multiply the least significant words
    mul     \C0, \A0, \B0       ; C0 = A0 * B0 (low word)
    umulh   \C1, \A0, \B0       ; C1 = A0 * B0 (high word)

    ; Add the cross-product of lower A0:B1 
    mul     \T0, \A0, \B1       ; T0 = A0 * B1 (low word)
    adds    \C1, \C1, \T0       ; C1 += T1
    adc     \C2, xzr, xzr       ; C2 = carry from previous addition
    ; Add the cross-prodoct of lower A1:B0
    mul     \T0, \A1, \B0       ; T1 = A1 * B0 (low word)
    adds    \C1, \C1, \T0       ; C1 += T1 (with carry)
    adc     \C2, \C2, xzr       ; C2 += carry from previous addition    
    ; to the same for the highers into C2
    umulh   \T0, \A0, \B1       ; T0 = A0 * B1 (high word)
    adds    \C2, \T0, \C2       ; C2 = T0 + C2
    adc     \C3, xzr, xzr       ; C3 = carry from previous addition
    umulh   \T0, \A1, \B0       ; T0 = A1 * B0 (high word)
    adds    \C2, \C2, \T0       ; C2 += T0 
    adc     \C3, \C3, xzr       ; C3 += carry from previous addition
    ; Multiply the most significant words
    mul     \T0, \A1, \B1
    adds    \C2, \C2, \T0
    adc     \C3, \C3, xzr
    umulh   \T0, \A1, \B1
    adc     \C3, \C3, \T0
.endm

// 𝐴𝐿 ∙ 𝐵𝐿 + 𝐴𝐻 ∙ 𝐵𝐻 − |𝐴𝐻 − 𝐴𝐿| ∙ |𝐵𝐻 − 𝐵𝐿| = RH · 2^256 + (RL + RH − RM ) · 2^128 + RL
// !!messes with A0-B3!!
.macro MUL256_KARATSUBA A0, A1, A2, A3, B0, B1, B2, B3, C0, C1, C2, C3, C4, C5, C6, C7, T0, T1, T2, T3, T4, T5, T6
    // AL * BL into C0-C3 = RL
    MUL128x128 \A0, \A1, \B0, \B1, \C0, \C1, \C2, \C3, \T0
    // AH * BH into C4-C7 = RH
    MUL128x128 \A2, \A3, \B2, \B3, \C4, \C5, \C6, \C7, \T0

    // |AH - AL| into A0-A3
    subs \A0, \A2, \A0
    sbcs \A1, \A3, \A1
    cinv \A0, \A0, MI  // If negative (MI), invert x2
    cinv \A1, \A1, MI  //If negative (MI), invert x3
    csetm \T5, MI     //T0 = -1 if negative, 0 otherwise
    adds \A0, \A0, \T5  //Add T0 to x2, set flags
    adc \A1, \A1, xzr  //Add carry to x3

    // |BH - BL| into B0-B3
    subs \B0, \B2, \B0
    sbcs \B1, \B3, \B1
    cinv \B0, \B0, MI  // If negative (MI), invert x2
    cinv \B1, \B1, MI  //If negative (MI), invert x3
    csetm \T6, MI     //T0 = -1 if negative, 0 otherwise
    adds \B0, \B0, \T6  //Add T0 to x2, set flags
    adc \B1, \B1, xzr  //Add carry to x3


    eor \T5, \T5, \T6
    sub \T5, \T5, #1

    // |AH - AL| * |BH - BL| into T0-T3 = M
    MUL128x128 \A0, \A1, \B0, \B1, \T0, \T1, \T2, \T3, \T4

    eor \T0, \T0, \T5
    eor \T1, \T1, \T5
    eor \T2, \T2, \T5
    eor \T3, \T3, \T5

    AND \T5, \T5, #1
    adds \T0, \T0, \T5
    adcs \T1, \T1, xzr
    adcs \T2, \T2, xzr
    adc \T3, \T3, xzr

    //RL + RH = A0-A3 (carry T4)
    adds \A0, \C0, \C4
    adcs \A1, \C1, \C5
    adcs \A2, \C2, \C6
    adcs \A3, \C3, \C7
    adc \T4, xzr, xzr // carry into T4

    // RL + RH - M 
    adds \C2, \A0, \T0
    adcs \C3, \A1, \T1
    adcs \C4, \A2, \T2 
    adcs \C5, \A3, \T3
    adc \T4, \T4, xzr

    // todo maybe we need this potential carry maybe not, what if the carry would be negative?
.endm


/* 
mul a la https://github.com/microsoft/PQCrypto-SIDH/blob/master/src/P503/ARM64/fp_arm64_asm.S
//  Operation: c [x2] = a [x0] * b [x1]
a = 8 words, b = 8 words, c = 16 words
*/
.global _uint_mul
_uint_mul:
    sub sp, sp, #240
    // save registers
    stp lr, x0, [sp, #0] 
    stp x1, x2, [sp, #16]
    stp x19, x20, [sp, #32]
    stp x21, x22, [sp, #48]
    stp x23, x24, [sp, #64]
    stp x25, x26, [sp, #80]
    stp x27, x28, [sp, #96]
    stp x29, x30, [sp, #112]


    // Load  low A
    ldp x3, x4, [x0, #0]
    ldp x5, x6, [x0, #16]
    // Load low B 
    ldp x11, x12, [x1, #0]
    ldp x13, x14, [x1, #16]
    // AL x BL = RL = x20-x27
    MUL256_KARATSUBA x3, x4, x5, x6, x11, x12, x13, x14, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x7, x8, x9, x10
   
    stp x20, x21, [x2, #0] // store RL on result
    stp x22, x23, [x2, #16]
    stp x24, x25, [x2, #32]
    stp x26, x27, [x2, #48]

    //load high A
    ldp x3, x4, [x0, #32]
    ldp x5, x6, [x0, #48]
    //load high B
    ldp x11, x12, [x1, #32]
    ldp x13, x14, [x1, #48]
    // AH x BH = RH = x20-x27
    MUL256_KARATSUBA x3, x4, x5, x6, x11, x12, x13, x14, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x7, x8, x9, x10
    stp x20, x21, [x2, #64] // store RH on result
    stp x22, x23, [x2, #80]
    stp x24, x25, [x2, #96]
    stp x26, x27, [x2, #112]

    // |AH - AL| into x3-x6 
    ldp x3, x4, [x0, #0] // load a again
    ldp x5, x6, [x0, #16]
    ldp x7, x8, [x0, #32]
    ldp x9, x10, [x0, #48]
    
    subs x3, x7, x3 // AH - AL
    sbcs x4, x8, x4
    sbcs x5, x9, x5
    sbcs x6, x10, x6

    cinv x3, x3, MI  // If negative (MI), invert x2
    cinv x4, x4, MI  //If negative (MI), invert x3
    cinv x5, x5, MI
    cinv x6, x6, MI
    csetm x30, MI     //T0 = -1 if negative, 0 otherwise
    adds x3, x3, x30  //Add T0 to x3, set flags
    adcs x4, x4, xzr  
    adcs x5, x5, xzr 
    adc x6, x6, xzr  //Add carry to x6

    // |BH - BL| into x7-x10
    ldp x7, x8, [x1, #0] // load b again
    ldp x9, x10, [x1, #16]
    ldp x11, x12, [x1, #32]
    ldp x13, x14, [x1, #48]

    subs x7, x11, x7 // BH - BL
    sbcs x8, x12, x8
    sbcs x9, x13, x9
    sbcs x10, x14, x10

    cinv x7, x7, MI  // If negative (MI), invert x7
    cinv x8, x8, MI
    cinv x9, x9, MI
    cinv x10, x10, MI
    csetm x16, MI     //x11 = -1 if negative, 0 otherwise
    adds x7, x7, x16  //Add T0, set flags
    adcs x8, x8, xzr
    adcs x9, x9, xzr
    adc x10, x10, xzr

    eor x30, x30, x16 // combine signs
    sub x30, x30, #1

    // |AH - AL| * |BH - BL| into x20-x27 = M
    MUL256_KARATSUBA x3, x4, x5, x6, x7, x8, x9, x10, x20, x21, x22, x23, x24, x25, x26, x27, x11, x12, x13, x14, x15, x28, x29
    // if sign is negative, invert and add 1
   
    eor x20, x20, x30
    eor x21, x21, x30
    eor x22, x22, x30
    eor x23, x23, x30
    eor x24, x24, x30
    eor x25, x25, x30
    eor x26, x26, x30
    eor x27, x27, x30

    and x30, x30, #1

    adds x20, x20, x30
    adcs x21, x21, xzr
    adcs x22, x22, xzr
    adcs x23, x23, xzr
    adcs x24, x24, xzr
    adcs x25, x25, xzr
    adcs x26, x26, xzr
    adc x27, x27, xzr

    // RL + RH = x3-x10 (carry x11)
    ldp x3, x4, [x2, #0] // load RL first 2
    ldp x5, x6, [x2, #64]    // load RH first 2
    adds x3, x3, x5
    adcs x4, x4, x6
    ldp x5, x6, [x2, #16] // load RL second 2
    ldp x7, x8, [x2, #80] // load RH second 2
    adcs x5, x5, x7
    adcs x6, x6, x8
    ldp x7, x8, [x2, #32] // load RL third 2
    ldp x9, x10, [x2, #96] // load RH third 2
    adcs x7, x7, x9
    adcs x8, x8, x10
    ldp x9, x10, [x2, #48] // load RL fourth 2
    ldp x11, x12, [x2, #112] // load RH fourth 2
    adcs x9, x9, x11
    adcs x10, x10, x12
    adc x11, xzr, xzr

    // RL + RH - M 
    adds x3, x3, x20
    adcs x4, x4, x21
    adcs x5, x5, x22
    adcs x6, x6, x23
    adcs x7, x7, x24
    adcs x8, x8, x25
    adcs x9, x9, x26
    adcs x10, x10, x27
    adc x11, x11, xzr // todo maybe this carry will actually be needed

    stp x3, x4, [x2, #32] // store middle result
    stp x5, x6, [x2, #48]
    stp x7, x8, [x2, #64]
    stp x9, x10, [x2, #80]

    //restore registers 
    ldp lr, x0, [sp, #0]
    ldp x1, x2, [sp, #16]
    ldp x19, x20, [sp, #32]
    ldp x21, x22, [sp, #48]
    ldp x23, x24, [sp, #64]
    ldp x25, x26, [sp, #80]
    ldp x27, x28, [sp, #96]
    ldp x29, x30, [sp, #112]

    add sp, sp, #240
    ret


/* x0 = x0 == x1 
    return 1 if equal, 0 otherwise
    bool fp_eq(fp const *x, fp const *y)
*/
.global _fp_eq
_fp_eq:
    // Load 1st pair of elements and compute XOR
    ldr x2, [x0]
    ldr x3, [x1] 
    eor x2, x2, x3 //logical exclusive or, true if different
    // Load 2nd pair of elements and compute XOR
    ldr x3, [x0, #8]
    ldr x4, [x1, #8]
    eor x3, x3, x4
    orr x2, x2, x3 //logical or, true if one is true
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
void fp_set(fp *x, uint64_t y)
 */
.global _fp_set
_fp_set:
    sub sp, sp, #16
    str lr, [sp, #0]
    bl _uint_set // x0 = x1
    ldr lr, [sp, #0]
    add sp, sp, #16
    mov x1, x0
    b _fp_enc


/*
encode x1 to x0 for montogomery
x0 = fp destination
x1 = uint to encode to montgommery
to encode just monte mul with r_squared_mod_p
void fp_enc(fp *x, uint const *y)
 */
.global _fp_enc
_fp_enc:
    adrp x2, _r_squared_mod_p@PAGE // load the address of r_squared_mod_p into x2 
    add x2, x2, _r_squared_mod_p@PAGEOFF // add the offset of r_squared_mod_p to x2
    b _fp_mul3

/*
decode x1 to x0 from montogomery
x0 = dec(x1)
void fp_dec(uint *x, fp const *y)
 */
.global _fp_dec
_fp_dec:
    adrp x2, _uint_1@PAGE
    add x2, x2, _uint_1@PAGEOFF
    b _fp_mul3


/*
Monti x0 = x1 * x0
void fp_mul2(fp *x, fp const *y)
 */
.global _fp_mul2
_fp_mul2:
    mov x2, x0 //move the result address to x2
    b _fp_mul3

/*
Montgomery multiplication
x0 = x1 * x2
void fp_mul3(fp *x, fp const *y, fp const *z)
*/
.global _fp_mul3
_fp_mul3:
    sub sp, sp, #224 // make space in the stack for 56 words
    stp lr, x0, [sp, #0] // store lr and result address
    stp x19, x20, [sp, #16] //store x19 and x20 to avoid segmentation fault
    stp x21, x22, [sp, #32] //store x21 and x22 to avoid segmentation fault

    mov x0, x2 // Move x2 to x0 for multiplication
    add x2, sp, #64 // result for mul = stack address + 16 + (16+8*16) words
    bl _uint_mul // x2 = x0 * x1
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

not defined in fp.c
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
    bl _uint_mul
    mov x1, x2 // copy result address to x1
    // q = lower 8 words of x1
    // C ← (a + p*q)/R
    // x0 = p
    adrp x0, _p@PAGE
    add x0, x0, _p@PAGEOFF
    add x2, sp, #152 // result of multiplication p*q 16 words from sp#152-280
    bl _uint_mul
    mov x0, x2 // x0 = p*q
    ldr x1, [sp, #16] // load address of a into x1 
    add x2, sp, #280 // result again 16 words from sp #280-408
    bl _add2_16_words
    // Result in higher 8 words of x2
    add x2, x2, #64 // 
    // If C >= p then C = C - p
    LOAD_8_WORD_NUMBER2 x3, x4, x5, x6, x7, x8, x9, x10, x2
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
    STORE_8_WORD_NUMBER2 x3, x4, x5, x6, x7, x8, x9, x10, x1    
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

/*
x0 = x0 + x1
void fp_add2(fp *x, fp const *y)
*/
.global _fp_add2
_fp_add2:
    mov x2, x0 // x0 is now also x2
    b _fp_add3

/*
x0 = x1 + x2 mod p
void fp_add3(fp *x, fp const *y, fp const *z)
*/ 
.global _fp_add3
_fp_add3:

    sub sp, sp, #48
    str x17, [sp, #0] 
    stp x19, x20, [sp, #16]
    stp x21, x22, [sp, #32]

    // Load first Number in register X3-X10
    LOAD_8_WORD_NUMBER2 x3, x4, x5, x6, x7, x8, x9, x10, x1
    // Load second Number in register X12-X19
    LOAD_8_WORD_NUMBER2 x12, x13, x14, x15, x16, x17, x19, x20, x2

    // Add a + b with carry into register X3-X11
    ADDS x3, x3, x12 
    ADCS x4, x4, x13
    ADCS x5, x5, x14
    ADCS x6, x6, x15
    ADCS x7, x7, x16
    ADCS x8, x8, x17
    ADCS x9, x9, x19
    ADCS x10, x10, x20
    ADC x11, xzr, xzr

    //Load prime
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
    SBCS x11, x11, xzr
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

    // Store result in x0
    STORE_8_WORD_NUMBER2 x3, x4, x5, x6, x7, x8, x9, x10, x0

    ldr x17, [sp, #0]
    ldp x19, x20, [sp, #16]
    ldp x21, x22, [sp, #32]
    add sp, sp, #48
    ret

/*
x0 = x0 - x1
void fp_sub2(fp *x, fp const *y)
*/
.global _fp_sub2
_fp_sub2:
    mov x2, x1
    mov x1, x0

/*
x0 = x1 - x2 mod p
void fp_sub3(fp *x, fp const *y, fp const *z)
*/
.global _fp_sub3
_fp_sub3:
    sub sp, sp, #112 // make space on the stack 16 + 64
    str lr, [sp, #0]
    str x0, [sp, #8]
    str x1, [sp, #16] // store x1 for the addition later
    add x0, sp, #48 // result 8 words 24 - 88 --> create the new x0 address on the stack


    mov x1, x2 // move x2 to x1 for the minus function
    bl _minus_number // x0 = -x1
    mov x2, x0
    ldr x0, [sp, #8] // load x0 from the stack inserted above
    ldr x1, [sp, #16] // load x1 from the stack inserted above
    bl _fp_add3 // x0 = x1 + x2
    ldr lr, [sp, #0] // load back lr
    add sp, sp, #112 // give back the stack

    ret
/*
x0 = -x1
not in fp.c
x0 = p - x1
*/
_minus_number:

    sub sp, sp, #32
    stp x16, x17, [sp, #0]
    stp x19, x20, [sp, #16]
    
    // Load number we want minus of into register X3-X10
    LOAD_8_WORD_NUMBER2 x2, x3, x4, x5, x6, x7, x8, x9, x1

    // Load the prime
    LOAD_511_PRIME x10, x11, x12, x13, x14, x15, x16, x17

    // p - a
    SUBS x2, x10, x2
    SBCS x3, x11, x3
    SBCS x4, x12, x4
    SBCS x5, x13, x5
    SBCS x6, x14, x6
    SBCS x7, x15, x7
    SBCS x8, x16, x8
    SBC x9, x17, x9

    // check if a = 0 by orr x2-x9 
    orr x19, x2, x3
    orr x19, x19, x4
    orr x19, x19, x5
    orr x19, x19, x6
    orr x19, x19, x7
    orr x19, x19, x8
    orr x19, x19, x9

    // check if a is really 0
    cmp x19, #0
    cset x19, eq // x19 = 1 if a was 0, 0 otherwise
    LSL x19, x19, #63
    ASR x19, x19, #63 //arithmetic shift (will take the value of msb)


    // and the prime (if a was 0 then we and with 1, otherwise 0)
    and x10, x10, x19
    and x11, x11, x19
    and x12, x12, x19
    and x13, x13, x19
    and x14, x14, x19
    and x15, x15, x19
    and x16, x16, x19
    and x17, x17, x19

    // subtract the prime from the result (this should only happen if result = prime)
    SUBS x2, x2, x10
    SBCS x3, x3, x11
    SBCS x4, x4, x12
    SBCS x5, x5, x13
    SBCS x6, x6, x14
    SBCS x7, x7, x15
    SBCS x8, x8, x16
    SBC x9, x9, x17

    ldp x16, x17, [sp, #0]
    ldp x19, x20, [sp, #16]
    STORE_8_WORD_NUMBER2 x2, x3, x4, x5, x6, x7, x8, x9, x0

    add sp, sp, #32
    ret

/*
todo mul counter?
x0 = x1^2 mod p
void fp_sq2(fp *x, fp const *y)
*/
.global _fp_sq2
_fp_sq2:
    mov x2, x1 // x2 = x1, fake it for x1 * x1
    b _fp_mul3 // x0 = x1 * x2

/*
x0 = x0^2
void fp_sq1(fp *x)
*/
.global _fp_sq1
_fp_sq1:
    mov x1, x0 //fake it for x0 * x0
    b _fp_sq2

/*
Calculate the inverse of x0 with little fermat
x0 = x0^(p-2) mod p = x0^(-1) mod p
we want to override a[x0] only at the very end

*/
.global _fp_inv
_fp_inv:
    adrp x1, _p_minus_2@PAGE  //get _p_minus_2 address into x1 for the fp_pow function
    add x1, x1, _p_minus_2@PAGEOFF //add offset of _p_minus_2 to x1
    b _fp_pow //use the power of fermat
    

/*
c[x0] = a[x0]^b[x1] mod p
Right-To_left
Output: md mod n
1: a ← 1 ; m ← a
2: for i = 0 to k − 1 do
3:  if di = 1 then
4:      a ← a × m mod n
5:   m ← m^2 mod n
6: return a
*/
.global _fp_pow
_fp_pow:
    sub sp, sp, #192   // make place for result 8*8 (#0), lr(#64), x0(#72), x1(#80), x2(#88), x3(#96), x4(#104), x5(#112), address of b (#120), address of m (#128)

    //where x0 is the result address
    // x1 is the counter for the number of words
    // x2 is the offset from the base address of b
    // x4 is the bit counter per word of b
    // x5 is the word counter
    stp lr, x0, [sp, #64] // store lr and address of x0 to get them back later
    str x1, [sp, #120] //store b address

    add x1, sp, #128 // space for m
    COPY_8_WORD_NUMBER x0, x1, x3, x4 // m = a

    // init stack result to 1
    mov x1, xzr // 0 into x1
    stp x1, x1, [sp, #0]
    stp x1, x1, [sp, #16]
    stp x1, x1, [sp, #32]
    stp x1, x1, [sp, #48]
    mov x1, #1
    str x1, [sp, #0] // init result with 1 
    // encode 1
    add x0, sp, #0
    mov x1, x0
    bl _fp_enc // x0 = 1 encoded


    ldr x0, [sp, #120] // load back b to get its length
    // get position of msb 1 bit of b
    bl _uint_len // x0 = position of last 1 in b x0 = len(x0)
    mov x5, x0 // counter of total len
    mov x1, #8          ; Counter for the number of words (8 words in total)
    mov x2, #0          ; Offset from the base address

_fp_pow_word_loop:
    ldr x3, [sp, #120] // load address of b
    add x3, x3, x2 // add offset
    ldr x3, [x3] // load the word
    mov x4, #64 // init bit counter

_fp_pow_bit_loop:
    cbz x5, _fp_pow_finished // finish if total counter = 0

    stp x1, x2, [sp, #80] // store them registers
    stp x3, x4, [sp, #96]
    str x5, [sp, #112]
    tst x3, #1        ; Test the least significant bit of x3
    beq _fp_pow_bit_is_zero // branch if is zero
    // bit is one

_fp_pow_bit_is_one:

    add x0, sp, #0 // =a
    add x1, sp, #128 // =m
    bl _fp_mul2 // a = a * m

    add x0, sp, #128 // =m
    bl _fp_sq1 // m = m^2
    b _fp_pow_end_of_bit

_fp_pow_bit_is_zero:
    add x0, sp, #128 // =m
    bl _fp_sq1 // m = m^2

_fp_pow_end_of_bit:
    ldp x1, x2, [sp, #80] // restore the registers
    ldp x3, x4, [sp, #96]
    ldr x5, [sp, #112]
    subs x5, x5, #1 // total counter -1
    lsr x3, x3, #1 // shift current word to the right by 1
    subs x4, x4, #1 // decrement bit counter
    b.ne _fp_pow_bit_loop // if not 0 get next bit
    add x2, x2, #8 // new word offset
    subs x1, x1, #1 // decrement word counter
    b.ne _fp_pow_word_loop // if in the first 8 words, go normal word

_fp_pow_finished:
    // store result in x0 address
    add x0, sp, #0 // result address in stack
    ldr x1, [sp, #72] // load initial result address
    COPY_8_WORD_NUMBER x0, x1, x3, x4
    ldr lr, [sp, #64]
    add sp, sp, #192
    ret


/*
this will for some reason not count to the mul counter
todo count reset the mulcounter to the value before the function
checks for the remainder
bool fp_issquare(fp *x)
*/
.global _fp_issquare
_fp_issquare:
    sub sp, sp, #16
    str lr, [sp, #0] //bad_access
    adrp x1, _p_minus_1_halves@PAGE
    add x1, x1, _p_minus_1_halves@PAGEOFF
    bl _fp_pow
    adrp x1, _fp_1@PAGE
    add x1, x1, _fp_1@PAGEOFF
    mov x2, #64
    bl _memcmp
    cbnz x0, _not_square //compare non zero
    mov x0, #1  // If memcmp returns 0, set return value to true (1)
    b _issquare_end

_not_square:
    mov x0, #0  // Set return value to false (0)

_issquare_end:
    ldr lr, [sp, #0]
    add sp, sp, #16
    ret

/*
void fp_random(fp *x)
using uint_random
 */

.global _fp_random
_fp_random:
    adrp x1, _p@PAGE
    add x1, x1, _p@PAGEOFF
    b _uint_random
