.extern _r_squared_mod_p
.extern _p_minus_2
.extern _uint_1
.extern _p_minus_1_halves
.extern _p
.extern _fp_1
.extern _mu
.extern _fp_mul3


.data
.global _fp_sq_counter
_fp_sq_counter: .quad 0
.global _fp_inv_counter
_fp_inv_counter: .quad 0
.global _fp_mul_counter
_fp_mul_counter: .quad 0
.global _fp_sqt_counter
_fp_sqt_counter: .quad 0

.text
.align 4


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
x0 = x0^2
void fp_sq1(fp *x)
*/
.global _fp_sq1
_fp_sq1:
    mov x1, x0 //fake it for x0 * x0

/*
x0 = x1^2 mod p
void fp_sq2(fp *x, fp const *y)
*/
.global _fp_sq2
_fp_sq2:
    // load mul count pointer
    adrp x3, _fp_mul_counter@PAGE
    add x3, x3, _fp_mul_counter@PAGEOFF
    ldr x4, [x3] // pointer_value in x4
    sub sp, sp, #16
    stp lr, x4, [sp, #0] // store lr and pointer_value on stack
    str xzr, [x3] // set pointer_value to 0
    // add to sq counter
    adrp x3, _fp_sq_counter@PAGE
    add x3, x3, _fp_sq_counter@PAGEOFF
    ldr x3, [x3]
    cbz x3, 0f
    ldr x4, [x3]
    add x4, x4, #1
    str x4, [x3]

    0:
    mov x2, x1 // x2 = x1, fake it for x1 * x1
    bl _fp_mul3 // x0 = x1 * x2

    ldp lr, x4, [sp, #0] // load back lr and pointer_value
    add sp, sp, #16
    adrp x3, _fp_mul_counter@PAGE
    add x3, x3, _fp_mul_counter@PAGEOFF
    str x4, [x3] // restore pointer_value
    ret

/*
Calculate the inverse of x0 with little fermat
x0 = x0^(p-2) mod p = x0^(-1) mod p
we want to override a[x0] only at the very end

*/
.global _fp_inv
_fp_inv:


    // add to inv counter
    adrp x3, _fp_inv_counter@PAGE
	add x3, x3, _fp_inv_counter@PAGEOFF
	ldr x3, [x3, #0]  // load counter pointer 
	cbz x3, 0f // skip to 0f if pointer to mul_counter is 0 
	ldr x4, [x3, #0]  // load counter value 
	adds x4, x4, #1  // increase counter value 
	str x4, [x3, #0]

    0: //skip label
    B _fp_inv_hardcoded

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
        // load mul count pointer
    adrp x3, _fp_mul_counter@PAGE
    add x3, x3, _fp_mul_counter@PAGEOFF
    ldr x4, [x3] // pointer_value in x4
    sub sp, sp, #16
    stp lr, x4, [sp, #0] // store lr and pointer_value on stack
    str xzr, [x3] // set pointer_value to 0

    // update square counter
    adrp x3, _fp_sqt_counter@PAGE
    add x3, x3, _fp_sqt_counter@PAGEOFF
    ldr x3, [x3]
    cbz x3, 0f
    ldr x4, [x3]
    add x4, x4, #1
    str x4, [x3]
    0:

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
    
    ldp lr, x4, [sp, #0] // load back lr and pointer_value
    add sp, sp, #16
    adrp x3, _fp_mul_counter@PAGE
    add x3, x3, _fp_mul_counter@PAGEOFF
    str x4, [x3] // restore pointer_value

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
