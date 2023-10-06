.global add_numbers
.section .text

// p512
p512:
.quad   0x1b81b90533c6c87b
.quad   0xc2721bf457aca835
.quad   0x516730cc1f0b4f25
.quad   0xa7aac6c567f35507
.quad   0x5afbfcc69322c9cd
.quad   0xb42d083aedc88c42
.quad   0xfc8ab0d15e3e4c4a
.quad   0x65b48e8f740f89bf

add_numbers:

    // Load first Number in register X3-X10
    LDP x3, x4, [x0,#0] 
    LDP x5, x6, [x0,#16]
    LDP x7, x8, [x0,#32]
    LDP x9, x10, [x0, #48]

    // Load second Number in register X12-X19
    LDP x12, x13, [x1,#0] 
    LDP x14, x15, [x1,#16]
    LDP x16, x17, [x1,#32]
    LDP x18, x19, [x1,#48]

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
    LDR x12, p512
    LDR x13, p512 + 8
    LDR x14, p512 + 16
    LDR x15, p512 + 24
    LDR x16, p512 + 32
    LDR x17, p512 + 40
    LDR x18, p512 + 48
    LDR x19, p512 + 56

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
    stp x3, x4,  [x2,#0]
    stp x5, x6,  [x2,#16]
    stp x7, x8,  [x2,#32]
    stp x9, x10, [x2,#48]
    ret
