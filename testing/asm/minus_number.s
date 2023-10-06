.include "asm/macros.s"
.global minus_number
.section .text

// it calculated p - a
// Gets the number from x0 and stores the result to x1
// The number that is input from x0 must be smaller than p
minus_number:
     // Load number we want minus of into register X3-X10
    LOAD_8_WORD_NUMBER x2, x3, x4, x5, x6, x7, x8, x9, x0

    // Load the prime
    LOAD_511_PRIME x10, x11, x12, x13, x14, x15, x16, x17

    SUBS x2, x10, x2
    SBCS x3, x11, x3
    SBCS x4, x12, x4
    SBCS x5, x13, x5
    SBCS x6, x14, x6
    SBCS x7, x15, x7
    SBCS x8, x16, x8
    SBC x9, x17, x9

    STORE_8_WORD_NUMBER x3, x4, x5, x6, x7, x8, x9, x10, x1
    ret
