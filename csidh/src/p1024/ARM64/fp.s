/* DO EDIT! generated by autogen */
.extern _r_squared_mod_p
.extern _p_minus_2
.extern _uint_1
.extern _p_minus_1_halves
.extern _p
.extern _fp_1
.extern _fp_mul3
.extern _uint_eq
.extern _uint_set
.extern _uint_add3
.extern _uint_sub3
.extern _uint_len
.extern _uint_random
.extern _fp_inv_hardcoded

.align 4
.data
.global _fp_sq_counter
_fp_sq_counter: .quad 0
.global _fp_mul_counter
_fp_mul_counter: .quad 0
.global _fp_inv_counter
_fp_inv_counter: .quad 0
.global _fp_sqt_counter
_fp_sqt_counter: .quad 0
.global _fp_addsub_counter
_fp_addsub_counter: .quad 0

.text
/*
 x0 = [x0] == [x1]  
*/
.global _fp_eq
_fp_eq: 
	b _uint_eq

/*
 [x0] = [x1,0,0,0,0] and encode to montgomery space  
*/
.global _fp_set
_fp_set: 
	sub sp, sp, #16
	str lr, [sp, #0]
	bl _uint_set
	mov x1, x0  // move result to x1 (input for fp_enc) 
	ldr lr, [sp, #0]
	add sp, sp, #16
	b _fp_enc

/*
 [x0] = [x1] * [r_squared_mod_p] mod [p]  
*/
.global _fp_enc
_fp_enc: 
	adrp x2, _r_squared_mod_p@PAGE
	add x2, x2, _r_squared_mod_p@PAGEOFF
	b _fp_mul3

/*
 [x0] = [x1] * [_uint_1] mod [p] = decoded [x1] out of montgomery space  
*/
.global _fp_dec
_fp_dec: 
	adrp x2, _uint_1@PAGE
	add x2, x2, _uint_1@PAGEOFF
	b _fp_mul3
/*
 [x0] = [x0] * [x1] mod [p]  
*/
.global _fp_mul2
_fp_mul2: 
	mov x2, x0  // move x0 to x2 
	b _fp_mul3

/*
 [x0] = [x0] + [x1] mod [p]  
*/
.global _fp_add2
_fp_add2: 
	mov x2, x0  // move x0 to x2 
	/* straight into fp_add3 */

/*
 [x0] = [x1] + [x2] mod [p]  
*/
.global _fp_add3
_fp_add3: 
	adrp x3, _fp_addsub_counter@PAGE
	add x3, x3, _fp_addsub_counter@PAGEOFF
	ldr x3, [x3, #0]  // load counter pointer 
	cbz x3, 0f // skip to 0f if pointer to mul_counter is 0 
	ldr x4, [x3, #0]  // load counter value 
	adds x4, x4, #1  // increase counter value 
	str x4, [x3, #0]

	0: // skip label
	sub sp, sp, #16
	stp x0, lr, [sp, #0]
	bl _uint_add3 // this returns the carry in x0
	mov x1, x0  // move the carry of a + b to x1 
	ldp x0, lr, [sp, #0]
	add sp, sp, #16
	b _reduce_once

/*
 [x0] = [x0]x1 - [p] mod [p] 
 x1 = potential overflow  
*/
.global _reduce_once
_reduce_once: 
	adrp x15, _p@PAGE
	add x15, x15, _p@PAGEOFF
	/* Limbs 0 - 3 */
	ldp x3, x4, [x0, #0]  // load A 
	ldp x5, x6, [x0, #16]  // load A 
	ldp x7, x8, [x15, #0]  // load P 
	ldp x9, x10, [x15, #16]  // load P 
	subs x11, x3, x7  
	sbcs x12, x4, x8  
	sbcs x13, x5, x9  
	sbcs x14, x6, x10  
	stp x11, x12, [x0, #0]  // store result 
	stp x13, x14, [x0, #16]  // store result 
	/* Limbs 4 - 7 */
	ldp x3, x4, [x0, #32]  // load A 
	ldp x5, x6, [x0, #48]  // load A 
	ldp x7, x8, [x15, #32]  // load P 
	ldp x9, x10, [x15, #48]  // load P 
	sbcs x11, x3, x7  
	sbcs x12, x4, x8  
	sbcs x13, x5, x9  
	sbcs x14, x6, x10  
	stp x11, x12, [x0, #32]  // store result 
	stp x13, x14, [x0, #48]  // store result 
	/* Limbs 8 - 11 */
	ldp x3, x4, [x0, #64]  // load A 
	ldp x5, x6, [x0, #80]  // load A 
	ldp x7, x8, [x15, #64]  // load P 
	ldp x9, x10, [x15, #80]  // load P 
	sbcs x11, x3, x7  
	sbcs x12, x4, x8  
	sbcs x13, x5, x9  
	sbcs x14, x6, x10  
	stp x11, x12, [x0, #64]  // store result 
	stp x13, x14, [x0, #80]  // store result 
	/* Limbs 12 - 15 */
	ldp x3, x4, [x0, #96]  // load A 
	ldp x5, x6, [x0, #112]  // load A 
	ldp x7, x8, [x15, #96]  // load P 
	ldp x9, x10, [x15, #112]  // load P 
	sbcs x11, x3, x7  
	sbcs x12, x4, x8  
	sbcs x13, x5, x9  
	sbcs x14, x6, x10  
	stp x11, x12, [x0, #96]  // store result 
	stp x13, x14, [x0, #112]  // store result 
	/* Final carry of a+b-p */
	sbcs x1, x1, xzr  // potential overflow of a+b 
	sbcs x1, xzr, xzr  // if a-p negative, carry is 1 
	/* AND P and a + p */
	/* Limbs 0 - 3 */
	ldp x3, x4, [x0, #0]  // load A 
	ldp x5, x6, [x0, #16]  // load A 
	ldp x7, x8, [x15, #0]  // load P 
	ldp x9, x10, [x15, #16]  // load P 
	and x7, x7, x1  
	and x8, x8, x1  
	and x9, x9, x1  
	and x10, x10, x1  

	adds x11, x3, x7  
	adcs x12, x4, x8  
	adcs x13, x5, x9  
	adcs x14, x6, x10  
	stp x11, x12, [x0, #0]  // store result 
	stp x13, x14, [x0, #16]  // store result 
	/* Limbs 4 - 7 */
	ldp x3, x4, [x0, #32]  // load A 
	ldp x5, x6, [x0, #48]  // load A 
	ldp x7, x8, [x15, #32]  // load P 
	ldp x9, x10, [x15, #48]  // load P 
	and x7, x7, x1  
	and x8, x8, x1  
	and x9, x9, x1  
	and x10, x10, x1  

	adcs x11, x3, x7  
	adcs x12, x4, x8  
	adcs x13, x5, x9  
	adcs x14, x6, x10  
	stp x11, x12, [x0, #32]  // store result 
	stp x13, x14, [x0, #48]  // store result 
	/* Limbs 8 - 11 */
	ldp x3, x4, [x0, #64]  // load A 
	ldp x5, x6, [x0, #80]  // load A 
	ldp x7, x8, [x15, #64]  // load P 
	ldp x9, x10, [x15, #80]  // load P 
	and x7, x7, x1  
	and x8, x8, x1  
	and x9, x9, x1  
	and x10, x10, x1  

	adcs x11, x3, x7  
	adcs x12, x4, x8  
	adcs x13, x5, x9  
	adcs x14, x6, x10  
	stp x11, x12, [x0, #64]  // store result 
	stp x13, x14, [x0, #80]  // store result 
	/* Limbs 12 - 15 */
	ldp x3, x4, [x0, #96]  // load A 
	ldp x5, x6, [x0, #112]  // load A 
	ldp x7, x8, [x15, #96]  // load P 
	ldp x9, x10, [x15, #112]  // load P 
	and x7, x7, x1  
	and x8, x8, x1  
	and x9, x9, x1  
	and x10, x10, x1  

	adcs x11, x3, x7  
	adcs x12, x4, x8  
	adcs x13, x5, x9  
	adcs x14, x6, x10  
	stp x11, x12, [x0, #96]  // store result 
	stp x13, x14, [x0, #112]  // store result 
	ret 


/*
 [x0] = [x0] - [x1] mod [p]  
*/
.global _fp_sub2
_fp_sub2: 
	mov x2, x1  // move x1 to x2 
	mov x1, x0  // move x0 to x1 
	/* straight into fp_sub3 */

/*
 [x0] = [x1] - [x2] mod [p] 
 saving temp of x2 in the stack might not be necessary but better safe then sorry  
*/
.global _fp_sub3
_fp_sub3: 
	/* we add -[x2] by first calculating [p] - [x2] */
	sub sp, sp, #160
	stp x0, x1, [sp, #0]
	str lr, [sp, #16]
	/* [temp] = [p] - [x2] */
	adds x0, sp, #24  
	adrp x1, _p@PAGE
	add x1, x1, _p@PAGEOFF
	bl _uint_sub3 
	ldp x0, x1, [sp, #0]  
	adds x2, sp, #24  
	/* [x0] = [x1] + [temp] mod [p] */
	bl _fp_add3
	ldp x0, x1, [sp, #0]
	ldr lr, [sp, #16]
	add sp, sp, #160
	ret


/*
 [x0] = [x0] * [x0] mod [p]  
*/
.global _fp_sq1
_fp_sq1: 
	/* straight into fp_sq2 */
	mov x1, x0  // move x0 to x1 

/*
 [x0] = [x1] * [x1] mod [p]  
*/
.global _fp_sq2
_fp_sq2: 
	/* First we set the mul counter pointer to 0, so it doesnt get updated, later we restore it */
	adrp x3, _fp_mul_counter@PAGE
	add x3, x3, _fp_mul_counter@PAGEOFF
	ldr x4, [x3, #0]  // load counter pointer 
	sub sp, sp, #32
	stp lr, x3, [sp, #0]
	str x4, [sp, #16]
	str xzr, [x3, #0]

	/* Now count up sq_counter */
	adrp x3, _fp_sq_counter@PAGE
	add x3, x3, _fp_sq_counter@PAGEOFF
	ldr x3, [x3, #0]  // load counter pointer 
	cbz x3, 0f // skip to 0f if pointer to mul_counter is 0 
	ldr x4, [x3, #0]  // load counter value 
	adds x4, x4, #1  // increase counter value 
	str x4, [x3, #0]

	0: // skip label
	mov x2, x1  // move x1 to x2 for mul 
	bl _fp_mul3
	/* Restore Mul Counter */
	ldp lr, x3, [sp, #0]
	ldr x4, [sp, #16]
	add sp, sp, #32
	str x4, [x3, #0]
	ret


/*
 [x0] = [x0] ^ [p] - 2 mod [p] = [x1] ^ -1 mod [p]   
*/
.global _fp_inv
_fp_inv: 
	/* Count up inv_counter */
	adrp x3, _fp_inv_counter@PAGE
	add x3, x3, _fp_inv_counter@PAGEOFF
	ldr x3, [x3, #0]  // load counter pointer 
	cbz x3, 0f // skip to 0f if pointer to mul_counter is 0 
	ldr x4, [x3, #0]  // load counter value 
	adds x4, x4, #1  // increase counter value 
	str x4, [x3, #0]

	0: // skip label
	/* We use the hardcoded inverse by djb */
	B _fp_inv_hardcoded

/*
 [x0] = [x0] ^ [x1] mod [p] 
 a ← 1 ; m ← a 
 for i = 0 to k − 1: 
    if di = 1 then a ← a · m mod n 
    m ← m · m mod n 
We add a dummy to make it time-constant  
*/
.global _fp_pow
_fp_pow: 
	sub sp, sp, #464
	stp lr, x0, [sp, #0]
	stp x1, x2, [sp, #16]
	stp x19, x20, [sp, #32]
	stp x21, x22, [sp, #48]
	stp x23, x24, [sp, #64]

	mov x19, x0  // move x1 to x1_adr 
	mov x20, x1  // move x2 to x2_adr 
	mov x25, x0  // move x0 to result_adr 
	adrp x3, _fp_1@PAGE
	add x3, x3, _fp_1@PAGEOFF
	/* m = x1 and a = fp1 */
	ldp x4, x5, [x19, #0]  // load x1 
	ldp x6, x7, [x19, #16]  
	ldp x8, x9, [x3, #0]  // load fp1 
	ldp x10, x11, [x3, #16]  
	stp x4, x5, [sp, #208]  // store x1 into m, offset m: 208, offset: 0 
	stp x6, x7, [sp, #224]  
	stp x8, x9, [sp, #80]  // store fp_1 into a, offset a: 80, offset: 0 
	stp x10, x11, [sp, #96]  
	ldp x4, x5, [x19, #32]  // load x1 
	ldp x6, x7, [x19, #48]  
	ldp x8, x9, [x3, #32]  // load fp1 
	ldp x10, x11, [x3, #48]  
	stp x4, x5, [sp, #240]  // store x1 into m, offset m: 208, offset: 32 
	stp x6, x7, [sp, #256]  
	stp x8, x9, [sp, #112]  // store fp_1 into a, offset a: 80, offset: 32 
	stp x10, x11, [sp, #128]  
	ldp x4, x5, [x19, #64]  // load x1 
	ldp x6, x7, [x19, #80]  
	ldp x8, x9, [x3, #64]  // load fp1 
	ldp x10, x11, [x3, #80]  
	stp x4, x5, [sp, #272]  // store x1 into m, offset m: 208, offset: 64 
	stp x6, x7, [sp, #288]  
	stp x8, x9, [sp, #144]  // store fp_1 into a, offset a: 80, offset: 64 
	stp x10, x11, [sp, #160]  
	ldp x4, x5, [x19, #96]  // load x1 
	ldp x6, x7, [x19, #112]  
	ldp x8, x9, [x3, #96]  // load fp1 
	ldp x10, x11, [x3, #112]  
	stp x4, x5, [sp, #304]  // store x1 into m, offset m: 208, offset: 96 
	stp x6, x7, [sp, #320]  
	stp x8, x9, [sp, #176]  // store fp_1 into a, offset a: 80, offset: 96 
	stp x10, x11, [sp, #192]  

	mov x21, #0  // init current word offset to 0 (limbs* 8) 
	mov x24, #16  // init word counter to 16 
_fp_pow_word_loop:
	mov x22, #64  // init bit counter 
	ldr x23, [x20, x21] // load current word of x2

_fp_pow_bit_loop:
	tst x23, #1 // check if least significant bit is 1
	beq _fp_pow_bit_is_zero // branch if 0 
_fp_pow_bit_is_one:
	add x0, sp, 80  // = a 
	add x1, sp, 208  // = m 
	bl _fp_mul2 // a = a * m 
	b _fp_pow_bit_finish
_fp_pow_bit_is_zero:
	add x0, sp, 336  // = dummy 
	add x1, sp, 208  // = m 
	bl _fp_mul2 // dummy = dummy * m 

_fp_pow_bit_finish:
	add x0, sp, 208  // = m 
	bl _fp_sq1 // m = m * m 
	lsr x23, x23, #1  // shift current word right by 1 
	subs x22, x22, #1  // decrease bit counter 
	b.ne _fp_pow_bit_loop // branch if bit counter != 0 
	add x21, x21, #8  // increase current word offset by 8 
	subs x24, x24, #1  // decrease word counter 
	b.ne _fp_pow_word_loop // branch if word counter != 0 

_fp_pow_end:
	mov x0, x25  // move result_adr to x0 
	/* Store a into result */
	ldp x4, x5, [sp, #80]  // load a 
	ldp x6, x7, [sp, #96]  
	ldp x8, x9, [sp, #112]  
	ldp x10, x11, [sp, #128]  
	stp x4, x5, [x0, #0]  // store a 
	stp x6, x7, [x0, #16]  
	stp x8, x9, [x0, #32]  
	stp x10, x11, [x0, #48]  
	ldp x4, x5, [sp, #144]  // load a 
	ldp x6, x7, [sp, #160]  
	ldp x8, x9, [sp, #176]  
	ldp x10, x11, [sp, #192]  
	stp x4, x5, [x0, #64]  // store a 
	stp x6, x7, [x0, #80]  
	stp x8, x9, [x0, #96]  
	stp x10, x11, [x0, #112]  

	/* Restore Stack */
	ldp lr, x0, [sp, #0]
	ldp x1, x2, [sp, #16]
	ldp x19, x20, [sp, #32]
	ldp x21, x22, [sp, #48]
	ldp x23, x24, [sp, #64]
	add sp, sp, #464
	ret

/*
 return 1 if [x0] is a square, 0 otherwise  
*/
.global _fp_issquare
_fp_issquare: 
	adrp x3, _fp_sqt_counter@PAGE
	add x3, x3, _fp_sqt_counter@PAGEOFF
	ldr x3, [x3, #0]  // load counter pointer 
	cbz x3, 0f // skip to 0f if pointer to mul_counter is 0 
	ldr x4, [x3, #0]  // load counter value 
	adds x4, x4, #1  // increase counter value 
	str x4, [x3, #0]

	0: // skip label
	adrp x1, _p_minus_1_halves@PAGE
	add x1, x1, _p_minus_1_halves@PAGEOFF
	bl _fp_pow // [x0] = [x0] ^ [p_minus1_halves] mod [p] 

	/* Check if [x0] == 1 == fp_1!! */
	adrp x1, _fp_1@PAGE
	add x1, x1, _fp_1@PAGEOFF
	bl _fp_eq // x0 = [x0] == [x1] 
	/* If equal (1) it is a quadratic residue!! */

	ret

.global _fp_random
_fp_random: 
	adrp x1, _p@PAGE
	add x1, x1, _p@PAGEOFF
	b _uint_random
