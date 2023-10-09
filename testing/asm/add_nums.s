.include "asm/macros.s"
.global add_numbers
.section .text


/* a + b mod p */
add_numbers:

    // Load first Number in register X3-X10
    LOAD_8_WORD_NUMBER x3, x4, x5, x6, x7, x8, x9, x10, x0
    // Load second Number in register X12-X19
    LOAD_8_WORD_NUMBER x12, x13, x14, x15, x16, x17, x19, x20, x1

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

    //Subtract Prime from a + b into register x3-x11, not(carry) into x30
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

    // Add x30 with register x12 - x20
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

    // Store result in x2
    STORE_8_WORD_NUMBER x3, x4, x5, x6, x7, x8, x9, x10, x2
    ret
