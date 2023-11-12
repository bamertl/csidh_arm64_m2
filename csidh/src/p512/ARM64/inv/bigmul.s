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
    adcs     \C3, \C3, xzr
    umulh   \T0, \A1, \B1
    adc     \C3, \C3, \T0
.endm


// 𝐴𝐿 ∙ 𝐵𝐿 + 𝐴𝐻 ∙ 𝐵𝐻 − |𝐴𝐻 − 𝐴𝐿| ∙ |𝐵𝐻 − 𝐵𝐿| = RH · 2^256 + (RL + RH − RM ) · 2^128 + RL
// !!messes with A0-B3!!
// needs 20 registers
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
    adc \C5, \C5, \T3

.endm

// not using x18 and x29 as apple states -> x3-x17, x19-x28 = 15 + 10 = 25 registers
.global _uint_mul_512
_uint_mul_512:
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
    // AL x BL = L = x11-x19
    MUL256_KARATSUBA x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23
    stp x11, x12, [x2, #0]
    stp x13, x14, [x2, #16]

    // load high A
    ldp x3, x4, [x0, #32]
    ldp x5, x6, [x0, #48]
    // load high B
    ldp x7, x8, [x1, #32]
    ldp x9, x10, [x1, #48]

    // AH x BH = H = x20-x27
    // carefull we need x11, x12 as temp
    MUL256_KARATSUBA x3, x4, x5, x6, x7, x8, x9, x10, x20, x21, x22, x23, x24, x25, x26, x27, x28, x30, x11, x12
    ldp x11, x12, [x2, #0] // restore x11,x12

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
    ldp x3, x4, [x0, #32]
    ldp x5, x6, [x0, #48]
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
    MUL256_KARATSUBA x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x25, x26, x27, x28, T0, T1, T2, T3, T4 

    // 2's complement if sign was 0  --> into x3-x10
    


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


