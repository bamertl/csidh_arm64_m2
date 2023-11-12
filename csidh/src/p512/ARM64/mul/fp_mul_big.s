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
    ; to the same for the highers into C2
    umulh   \T0, \A0, \B1       ; T0 = A0 * B1 (high word)
    adds    \C2, \T0, \C2       ; C2 = T0 + C2
    adcs     \C3, xzr, xzr       ; C3 = carry from previous addition
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


// 𝐴𝐿 ∙ 𝐵𝐿 + 𝐴𝐻 ∙ 𝐵𝐻 − |𝐴𝐻 − 𝐴𝐿| ∙ |𝐵𝐻 − 𝐵𝐿| = RH · 2^256 + (RL + RH − RM ) · 2^128 + RL
// !!messes with A0-B3!!
// needs 21 registers
.macro MUL256_KARATSUBA A0, A1, A2, A3, B0, B1, B2, B3, C0, C1, C2, C3, C4, C5, C6, C7, T0, T1, T2, T3, T4
    // AL * BL into C0-C3 = L
    MUL128x128 \A0, \A1, \B0, \B1, \C0, \C1, \C2, \C3, \T0
    // AH * BH into C4-C7 = H
    MUL128x128 \A2, \A3, \B2, \B3, \C4, \C5, \C6, \C7, \T0

    // + L*2^128 from (L+H-M)*2^128(2 words) 
    adds \T0, \C2, \C0
    adcs \T1, \C3, \C1
    adcs \T2, \C4, \C2
    adcs \T3, \C5, \C3
    adc  \T4, xzr, xzr

    // + H*2^128 from (L+H-M)*2^128(2 words)
    adds \C2, \T0, \C4
    adcs \C3, \T1, \C5
    adcs \C4, \T2, \C6
    adcs \C5, \T3, \C7
    adcs \C6, \T4, \C6
    adcs \C7, xzr, \C7

    // |AH - AL| into A0-A1 sign in A2
    subs \A0, \A2, \A0
    sbcs \A1, \A3, \A1
    // LO means the carry flag is 0, which means x1 was bigger than x0
    // calculate two's complement if negative
    cinv \A0, \A0, LO
    cinv \A1, \A1, LO
    // set sign to 1 if negative
    cset \A2, LO 
    adds \A0, \A0, \A2
    adc \A1, \A1, xzr

    // |BH - BL| into B0-B1 sign in B2
    subs \B0, \B2, \B0
    sbcs \B1, \B3, \B1
    // LO means the carry flag is 0, which means x1 was bigger than x0
    // calculate two's complement if negative
    cinv \B0, \B0, LO
    cinv \B1, \B1, LO
    cset \B2, LO
    adds \B0, \B0, \B2
    adc \B1, \B1, xzr

    // M = - (AH - AL) * (BH - BL) -> M = - eor(signA, signB) * |AH - AL| * |BH - BL|, if sign = 1 result needs two's complement
    // But then we also need to subtract, so we make the opposite, two's if sign = 0
    // combine sign into A2 -> 1 if result of mul will be negative
    eor \A2, \A2, \B2
    sub \A2, \A2, #1 // if 0 -> fffffff, if 1 -> 0
    // M = |AH - AL| * |BH - BL| into T0-T3 = M
          
    MUL128x128 \A0, \A1, \B0, \B1, \T0, \T1, \T2, \T3, \T4

    // 2's complement if sign was 0 
    eor \T0, \T0, \A2
    eor \T1, \T1, \A2
    eor \T2, \T2, \A2
    eor \T3, \T3, \A2

    and \T4, \A2, #1
    adds \T0, \T0, \T4
    adcs \T1, \T1, xzr
    adcs \T2, \T2, xzr
    adc \T3, \T3, xzr

   
    // +- M*2^128 from (L+H-M)*2^128(2 words)
    adds \C2, \C2, \T0
    adcs \C3, \C3, \T1
    adcs \C4, \C4, \T2
    adcs \C5, \C5, \T3
    adcs \C6, \C6, \A2
    adcs \C7, \C7, \A2

.endm

// not using x18 and x29 as apple states -> x3-x17, x19-x28 = 15 + 10 = 25 registers
.global _uint_mul_512x512
_uint_mul_512x512:

    // x11 - x19 = C0-C7, x20-x27 = C8-C15

    sub sp, sp, #112
    // save registers
    stp lr, x0, [sp, #0] 
    stp x1, x2, [sp, #16]
    stp x19, x20, [sp, #32]
    stp x21, x22, [sp, #48]
    stp x23, x24, [sp, #64]
    stp x25, x26, [sp, #80]
    stp x27, x28, [sp, #96]

    // Load  low A
    ldp x3, x4, [x0, #0]
    ldp x5, x6, [x0, #16]
    // Load low B 
    ldp x7, x8, [x1, #0]
    ldp x9, x10, [x1, #16]

    // AL x BL = L = x11-x19 = C0-C7
    MUL256_KARATSUBA x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x30
    stp x11, x12, [x2, #0]
    stp x13, x14, [x2, #16]

    // load high A
    ldp x3, x4, [x0, #32]
    ldp x5, x6, [x0, #48]
    // load high B
    ldp x7, x8, [x1, #32]
    ldp x9, x10, [x1, #48]

    // AH x BH = H = x20-x27
    // carefull we need x11, x12, x13 as temp
    MUL256_KARATSUBA x3, x4, x5, x6, x7, x8, x9, x10, x20, x21, x22, x23, x24, x25, x26, x27, x28, x30, x11, x12, x13
    ldp x11, x12, [x2, #0] // restore x11,x12
    ldp x13, x14, [x2, #16]
    // +L*2^256 from (L+H-M)*2^256(4 words offset) 

    adds x3, x15, x11 // T0 = C4 + C0
    adcs x4, x16, x12 // T1 = C5 + C1
    adcs x5, x17, x13 // T2 = C6 + C2
    adcs x6, x19, x14 // T3 = C7 + C3
    adcs x7, x20, x15 // T4 = C8 + C4
    adcs x8, x21, x16 // T5 = C9 + C5
    adcs x9, x22, x17 // T6 = C10 + C6
    adcs x10, x23, x19 // T7 = C11 + C7
    adcs x30, xzr, xzr // x30 = carry

    // +H*2^256 from (L+H-M)*2^256(4 words offset)
    adds x15, x3, x20 // C4 = T0 + C8
    adcs x16, x4, x21 // C5 = T1 + C9
    adcs x17, x5, x22 // C6 = T2 + C10
    adcs x19, x6, x23 // C7 = T3 + C11

    adcs x20, x7, x24 // C8 = T4 + C12
    adcs x21, x8, x25 // C9 = T5 + C13
    adcs x22, x9, x26 // C10 = T6 + C14
    adcs x23, x10, x27 // C11 = T7 + C15
    //carry prop
    adcs x24, x30, x24 // C12 = carry
    adcs x25, x25, xzr
    adcs x26, x26, xzr
    adcs x27, x27, xzr

    stp x24, x25, [x2, #96] // store C12-C15
    stp x26, x27, [x2, #112]

    // |AH - AL| x3-x6
    ldp x3, x4, [x0, #0]
    ldp x5, x6, [x0, #16]
    ldp x7, x8, [x0, #32]
    ldp x9, x10, [x0, #48]

    subs x3, x3, x7
    sbcs x4, x4, x8
    sbcs x5, x5, x9
    sbcs x6, x6, x10
    // calculate two's complement if negative 
    cinv x3, x3, LO
    cinv x4, x4, LO
    cinv x5, x5, LO
    cinv x6, x6, LO
    cset x30, LO
    adds x3, x3, x30
    adcs x4, x4, xzr
    adcs x5, x5, xzr
    adcs x6, x6, xzr

    // |BH - BL| x7-x10
    ldp x7, x8, [x1, #0]
    ldp x9, x10, [x1, #16]
    ldp x11, x12, [x1, #32] // we already saved x11-x14 (lowest pair)
    ldp x13, x14, [x1, #48]

    subs x7, x7, x11
    sbcs x8, x8, x12
    sbcs x9, x9, x13
    sbcs x10, x10, x14

    // calculate two's complement if negative
    cinv x7, x7, LO
    cinv x8, x8, LO
    cinv x9, x9, LO
    cinv x10, x10, LO
    cset x11, LO
    adds x7, x7, x11
    adcs x8, x8, xzr
    adcs x9, x9, xzr
    adcs x10, x10, xzr

    eor x30, x30, x11 // combined sign
    sub x30, x30, #1 // if 0 -> fffffff, if 1 -> 0
    //M = |AH - AL| * |BH - BL| = x11-x14, x25-x28
    str x19, [x2, #56] // load C7
    stp x20, x21, [x2, #64] // save x19-x23 used as temp in MUL256
    stp x22, x23, [x2, #80] 
    MUL256_KARATSUBA x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x25, x26, x27, x28, x19, x20, x21, x22, x23 
    ldr x19, [x2, #56] // restore C7
    ldp x20, x21, [x2, #64]
    ldp x22, x23, [x2, #80]

    // 2's complement if sign was 0  --> into x3-x10
    eor x3, x11, x30 
    eor x4, x12, x30
    eor x5, x13, x30
    eor x6, x14, x30
    eor x7, x25, x30
    eor x8, x26, x30
    eor x9, x27, x30
    eor x10, x28, x30

    and x28, x30, #1
    adds x3, x3, x28
    adcs x4, x4, xzr
    adcs x5, x5, xzr
    adcs x6, x6, xzr
    adcs x7, x7, xzr
    adcs x8, x8, xzr
    adcs x9, x9, xzr
    adcs x10, x10, xzr

    // +- M*2^256 from (L+H-M)*2^256(4 words offset)
    ldp x24, x25, [x2, #96] // load C12-C15
    ldp x26, x27, [x2, #112]
    // C4-C11 = x15-x23, C12-C15 = x24-x27 
    
    adds x15, x15, x3
    adcs x16, x16, x4
    adcs x17, x17, x5
    adcs x19, x19, x6
    adcs x20, x20, x7
    adcs x21, x21, x8
    adcs x22, x22, x9
    adcs x23, x23, x10

    adcs x24, x24, x30 // carry propagation x30 is ffff or 0
    adcs x25, x25, x30
    adcs x26, x26, x30
    adcs x27, x27, x30

    // store C4-C15
    stp x15, x16, [x2, #32]
    stp x17, x19, [x2, #48]
    stp x20, x21, [x2, #64]
    stp x22, x23, [x2, #80]
    stp x24, x25, [x2, #96]
    stp x26, x27, [x2, #112]

    // restore registers
    ldp lr, x0, [sp, #0] 
    ldp x1, x2, [sp, #16]
    ldp x19, x20, [sp, #32]
    ldp x21, x22, [sp, #48]
    ldp x23, x24, [sp, #64]
    ldp x25, x26, [sp, #80]
    ldp x27, x28, [sp, #96]

    add sp, sp, #112

    ret



//  Operation: c [x2] = a [x0] * b [x1]
//a = 8 words, b = 8 words, c = 8 words
// not using x18 and x29 as apple states -> x3-x17, x19-x28 = 15 + 10 = 25 registers
.global _uint_mul_lower
_uint_mul_lower:
    sub sp, sp, #240
    // save registers
    stp lr, x0, [sp, #0] 
    stp x1, x2, [sp, #16]
    stp x19, x20, [sp, #32]
    stp x21, x22, [sp, #48]
    stp x23, x24, [sp, #64]
    stp x25, x26, [sp, #80]
    stp x27, x28, [sp, #96]

    // Load  low A
    ldp x3, x4, [x0, #0]
    ldp x5, x6, [x0, #16]
    // Load low B 
    ldp x7, x8, [x1, #0]
    ldp x9, x10, [x1, #16]

    // AL x BL = L = x20-x27
    MUL256_KARATSUBA x3, x4, x5, x6, x7, x8, x9, x10, x20, x21, x22, x23, x24, x25, x26, x27, x11, x12, x13, x14, x15
    stp x20, x21, [x2, #0]
    stp x22, x23, [x2, #16]
    stp x24, x25, [x2, #32]
    stp x26, x27, [x2, #48]

    //restore registers 
    ldp lr, x0, [sp, #0]
    ldp x1, x2, [sp, #16]
    ldp x19, x20, [sp, #32]
    ldp x21, x22, [sp, #48]
    ldp x23, x24, [sp, #64]
    ldp x25, x26, [sp, #80]
    ldp x27, x28, [sp, #96]

    add sp, sp, #240
    ret


// with 2 complement if necessary
.global _abs_minus
_abs_minus:
    mov x3, #12
    mov x4, #0
    mov x5, #8
    mov x6, #0

    subs x3, x3, x5
    sbcs x4, x4, x6
    // LO means the carry flag is 0, which means x1 was bigger than x0
    cinv x3, x3, LO
    cinv x4, x4, LO
    cset x5, LO

    adds x3, x3, x5
    adc x4, x4, xzr

    mov x12, #0
    ret    


