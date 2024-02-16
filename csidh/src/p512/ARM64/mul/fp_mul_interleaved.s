.text
.align 2

p511:
.quad 0x1b81b90533c6c87b
.quad 0xc2721bf457aca835
.quad 0x516730cc1f0b4f25
.quad 0xa7aac6c567f35507
.quad 0x5afbfcc69322c9cd
.quad 0xb42d083aedc88c42
.quad 0xfc8ab0d15e3e4c4a
.quad 0x65b48e8f740f89bf

inv_min_p_mod_r: 
    .quad 0x66c1301f632e294d
big_p: 
    .quad 0x1b81b90533c6c87b, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507
    .quad 0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf

/* C = C + AI * B_even */
.macro mul_add_8x1_even,    AI,                                 \
                            C0, C1, C2, C3, C4, C5, C6, C7, C8, \
                            B0, B2, B4, B6,                     \
                            T0, T1, T2, T3, T4, T5, T6, T7 

    mul     \T0, \AI, \B0
    umulh   \T1, \AI, \B0
    mul     \T2, \AI, \B2
    umulh   \T3, \AI, \B2
    mul     \T4, \AI, \B4
    umulh   \T5, \AI, \B4
    mul     \T6, \AI, \B6
    umulh   \T7, \AI, \B6

    adds    \C0, \C0, \T0
    adcs    \C1, \C1, \T1
    adcs    \C2, \C2, \T2
    adcs    \C3, \C3, \T3
    adcs    \C4, \C4, \T4
    adcs    \C5, \C5, \T5
    adcs    \C6, \C6, \T6
    adcs    \C7, \C7, \T7
    adc     \C8, \C8, xzr

.endm 


/* C = C + AI * B_odd */
.macro mul_add_8x1_odd,     AI,                                 \
                            C0, C1, C2, C3, C4, C5, C6, C7, C8, \
                            B1, B3, B5, B7,                     \
                            T0, T1, T2, T3, T4, T5, T6, T7 

    mul     \T0, \AI, \B1
    umulh   \T1, \AI, \B1
    mul     \T2, \AI, \B3
    umulh   \T3, \AI, \B3
    mul     \T4, \AI, \B5
    umulh   \T5, \AI, \B5
    mul     \T6, \AI, \B7
    umulh   \T7, \AI, \B7

    adds    \C1, \C1, \T0
    adcs    \C2, \C2, \T1
    adcs    \C3, \C3, \T2
    adcs    \C4, \C4, \T3
    adcs    \C5, \C5, \T4
    adcs    \C6, \C6, \T5
    adcs    \C7, \C7, \T6
    adc     \C8, \C8, \T7

.endm 





/* C = C + AI * B */
.macro mul_add_8x1,     AI,                                 \
                        C0, C1, C2, C3, C4, C5, C6, C7, C8, \
                        B0, B1, B2, B3, B4, B5, B6, B7,     \
                        T0, T1, T2, T3, T4, T5, T6, T7

    mul_add_8x1_even    \AI,                                            \
                        \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7, \C8,    \
                        \B0, \B2, \B4, \B6,                             \
                        \T0, \T1, \T2, \T3, \T4, \T5, \T6, \T7 


    mul_add_8x1_odd     \AI,                                            \
                        \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7, \C8,    \
                        \B1, \B3, \B5, \B7,                             \
                        \T0, \T1, \T2, \T3, \T4, \T5, \T6, \T7 

.endm 



.macro mul_step,    K,                                      \
                    C0, C1, C2, C3, C4, C5, C6, C7, C8,     \
                    B0, B1, B2, B3, B4, B5, B6, B7,         \
                    T0, T1, T2, T3, T4, T5, T6, T7,         \
                    R0, A0, A1

    ldp \B0, \B1, [\A1, #00]
    ldp \B2, \B3, [\A1, #16]
    ldp \B4, \B5, [\A1, #32]
    ldp \B6, \B7, [\A1, #48]

    ldr \R0, [\A0 , 8*\K]       // load AI 

    mul_add_8x1     \R0,                                            \
                    \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7, \C8,    \
                    \B0, \B1, \B2, \B3, \B4, \B5, \B6, \B7,         \
                    \T0, \T1, \T2, \T3, \T4, \T5, \T6, \T7



    ldr \R0, inv_min_p_mod_r
    mul \R0, \R0, \C0  // mul C0 with inv_min_p_mod_r = q 

    /* C ← C + q*p */
    ldr \B0, big_p
    ldr \B1, big_p + 8
    ldr \B2, big_p + 16
    ldr \B3, big_p + 24
    ldr \B4, big_p + 32
    ldr \B5, big_p + 40
    ldr \B6, big_p + 48
    ldr \B7, big_p + 56

    mul_add_8x1     \R0,                                            \
                    \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7, \C8,    \
                    \B0, \B1, \B2, \B3, \B4, \B5, \B6, \B7,         \
                    \T0, \T1, \T2, \T3, \T4, \T5, \T6, \T7

.endm



.macro mul_step_0,  C0, C1, C2, C3, C4, C5, C6, C7, C8,         \
                    B0, B1, B2, B3, B4, B5, B6, B7,             \
                    T0, T1, T2, T3, T4, T5, T6, T7,             \
                    R0, A0, A1

    ldp     \B0, \B1, [\A1, #00]
    ldp     \B2, \B3, [\A1, #16]
    ldp     \B4, \B5, [\A1, #32]
    ldp     \B6, \B7, [\A1, #48]

    ldr     \R0, [\A0 , #00]

    mul     \C0, \R0, \B0
    umulh   \C1, \R0, \B0
    mul     \C2, \R0, \B2
    umulh   \C3, \R0, \B2
    mul     \C4, \R0, \B4
    umulh   \C5, \R0, \B4
    mul     \C6, \R0, \B6
    umulh   \C7, \R0, \B6

    mul     \T0, \R0, \B1
    umulh   \T1, \R0, \B1
    mul     \T2, \R0, \B3
    umulh   \T3, \R0, \B3
    mul     \T4, \R0, \B5
    umulh   \T5, \R0, \B5
    mul     \T6, \R0, \B7
    umulh   \T7, \R0, \B7

    adds    \C1, \C1, \T0
    adcs    \C2, \C2, \T1
    adcs    \C3, \C3, \T2
    adcs    \C4, \C4, \T3
    adcs    \C5, \C5, \T4
    adcs    \C6, \C6, \T5
    adcs    \C7, \C7, \T6
    adc     \C8, xzr, \T7



    ldr \R0, inv_min_p_mod_r
    mul \R0, \R0, \C0  // mul C0 with inv_min_p_mod_r = q 

    /* C ← C + q*p */
    ldr     \B0, big_p
    ldr     \B1, big_p + 8
    ldr     \B2, big_p + 16
    ldr     \B3, big_p + 24
    ldr     \B4, big_p + 32
    ldr     \B5, big_p + 40
    ldr     \B6, big_p + 48
    ldr     \B7, big_p + 56

    mul_add_8x1     \R0,                                            \
                    \C0, \C1, \C2, \C3, \C4, \C5, \C6, \C7, \C8,    \
                    \B0, \B1, \B2, \B3, \B4, \B5, \B6, \B7,         \
                    \T0, \T1, \T2, \T3, \T4, \T5, \T6, \T7

.endm

.global _fp_mul3
_fp_mul3: 
    /* Increment mulcounter */
	adrp x3, _fp_mul_counter@PAGE
	add x3, x3, _fp_mul_counter@PAGEOFF
	ldr x3, [x3]
	cbz x3, 0f
	ldr x4, [x3]
	add x4, x4, #1
	str x4, [x3]
	0:


    /* save variables on stack */
    sub sp, sp, #112
    stp x0, x1,     [sp, #00]
    stp x2, x19,    [sp, #16]
    stp x20, x21,   [sp, #32]
    stp x22, x23,   [sp, #48]
    stp x24, x25,   [sp, #64]
    stp x26, x27,   [sp, #80]
    stp x28, x30,   [sp, #96]
    
    mov x19, x1
    mov x20, x2



    mul_step_0  x21, x22, x23, x24, x25, x26, x27, x28, x30,    \
                x0,  x1,  x2,  x3,  x4,  x5,  x6,  x7,          \
                x8,  x9,  x10, x11, x12, x13, x14, x15,         \
                x17, x19, x20

    mul_step    1, \
                x22, x23, x24, x25, x26, x27, x28, x30, x21,    \
                x0,  x1,  x2,  x3,  x4,  x5,  x6,  x7,          \
                x8,  x9,  x10, x11, x12, x13, x14, x15,         \
                x17, x19, x20


    mul_step    2, \
                x23, x24, x25, x26, x27, x28, x30, x21, x22,    \
                x0, x1, x2, x3, x4, x5, x6, x7,                 \
                x8,  x9,  x10, x11, x12, x13, x14, x15,         \
                x17, x19, x20

    mul_step    3, \
                x24, x25, x26, x27, x28, x30, x21, x22, x23,    \
                x0, x1, x2, x3, x4, x5, x6, x7,                 \
                x8,  x9,  x10, x11, x12, x13, x14, x15,         \
                x17, x19, x20

    mul_step    4, \
                x25, x26, x27, x28, x30, x21, x22, x23, x24,    \
                x0, x1, x2, x3, x4, x5, x6, x7,                 \
                x8,  x9,  x10, x11, x12, x13, x14, x15,         \
                x17, x19, x20

    mul_step    5, \
                x26, x27, x28, x30, x21, x22, x23, x24, x25,    \
                x0, x1, x2, x3, x4, x5, x6, x7,                 \
                x8,  x9,  x10, x11, x12, x13, x14, x15,         \
                x17, x19, x20

    mul_step    6, \
                x27, x28, x30, x21, x22, x23, x24, x25, x26,    \
                x0, x1, x2, x3, x4, x5, x6, x7,                 \
                x8,  x9,  x10, x11, x12, x13, x14, x15,         \
                x17, x19, x20

    mul_step    7, \
                x28, x30, x21, x22, x23, x24, x25, x26, x27,    \
                x0,  x1,  x2,  x3,  x4,  x5,  x6,  x7,          \
                x8,  x9,  x10, x11, x12, x13, x14, x15,         \
                x17, x19, x20


    ldr x0, big_p
    ldr x1, big_p + 8
    ldr x2, big_p + 16
    ldr x3, big_p + 24
    ldr x4, big_p + 32
    ldr x5, big_p + 40
    ldr x6, big_p + 48
    ldr x7, big_p + 56

    subs x30, x30, x0       // sub C0 with P0 
    sbcs x21, x21, x1       // sub C1 with P1 
    sbcs x22, x22, x2       // sub C2 with P2 
    sbcs x23, x23, x3       // sub C3 with P3 
    sbcs x24, x24, x4       // sub C4 with P4
    sbcs x25, x25, x5       // sub C5 with P5
    sbcs x26, x26, x6       // sub C6 with P6
    sbcs x27, x27, x7       // sub C7 with P7

    sbcs x8, xzr, xzr       // carry into temp0

    ldr x9, [sp, #0]        // load dest addr pointer
    
    and x0, x0, x8          // and P0 with temp0
    and x1, x1, x8          // and P1 with temp0
    and x2, x2, x8          // and P2 with temp0
    and x3, x3, x8          // and P3 with temp0
    and x4, x4, x8          // and P4 with temp0
    and x5, x5, x8          // and P5 with temp0
    and x6, x6, x8          // and P6 with temp0
    and x7, x7, x8          // and P7 with temp0

    adds x30, x30, x0       // add C0 with P0
    adcs x21, x21, x1       // add C1 with P1
    adcs x22, x22, x2       // add C2 with P2
    adcs x23, x23, x3       // add C3 with P3
    adcs x24, x24, x4       // add C4 with P4
    adcs x25, x25, x5       // add C5 with P5
    adcs x26, x26, x6       // add C6 with P6
    adc  x27, x27, x7       // add C7 with P7

    stp x30, x21, [x9, #0]  // store C0 and C1
    stp x22, x23, [x9, #16] // store C2 and C3
    stp x24, x25, [x9, #32] // store C4 and C5
    stp x26, x27, [x9, #48] // store C6 and C7


    /* restore stack */
    ldp x0, x1, [sp, #0]
    ldp x2, x19, [sp, #16]
    ldp x20, x21, [sp, #32]
    ldp x22, x23, [sp, #48]
    ldp x24, x25, [sp, #64]
    ldp x26, x27, [sp, #80]
    ldp x28, x30, [sp, #96]
    add sp, sp, #112
    ret

