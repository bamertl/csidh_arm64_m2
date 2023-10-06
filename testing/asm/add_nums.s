.include "asm/macros.s"
.global add_numbers
.section .text



add_numbers:

    // Load first Number in register X3-X10
    LOAD_8_WORD_NUMBER x3, x4, x5, x6, x7, x8, x9, x10, x0
    // Load second Number in register X12-X19
    LOAD_8_WORD_NUMBER x12, x13, x14, x15, x16, x17, x18, x19, x1
    // Add a + b with carry into register X3-X11

    ADDS x3, x3, x12 
    ADCS x4, x4, x13
    ADCS x5, x5, x14
    ADCS x6, x6, x15
    ADCS x7, x7, x16
    ADCS x8, x8, x17
    ADCS x9, x9, x18
    ADCS x10, x10, x19
    ADC x11, xzr, xzr

    //Load prime
    LOAD_511_PRIME x12, x13, x14, x15, x16, x17, x18, x19

    b _check_bigger_prime


_check_bigger_prime:
    /*
    Check if the addition is greater than the prime
     If greater -> branch _addition_greater_then_prime:
    */
    CMP x11, #0
    b.hi _addition_greater_then_prime
    CMP x10, x19
    b.ne _not_equal
    CMP x9, x18
    b.ne _not_equal
    CMP x8, x17
    b.ne _not_equal
    CMP x7, x16
    b.ne _not_equal
    CMP x6, x15
    b.ne _not_equal
    CMP x5, x14
    b.ne _not_equal
    CMP x4, x13
    b.ne _not_equal
    // last one, if prime less than or equal
    CMP x12, x3
    b.ls _addition_greater_then_prime
    b _store_exit

_not_equal:
    b.hi _addition_greater_then_prime
    b _store_exit

/* We need to subtract p*/
_addition_greater_then_prime:
    SUBS x3, x3, x12
    SBCS x4, x4, x13
    SBCS x5, x5, x14
    SBCS x6, x6, x15
    SBCS x7, x7, x16
    SBCS x8, x8, x17
    SBCS x9, x9, x18
    SBCS x10, x10, x19
    SBC x11, x11, xzr
    b _check_bigger_prime

_store_exit:
    STORE_8_WORD_NUMBER x3, x4, x5, x6, x7, x8, x9, x10, x2
    ret
