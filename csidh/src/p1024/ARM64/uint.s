/* DO EDIT! generated by autogen */

.align 4
.text
.global _uint_0 
_uint_0: 
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
.global _uint_1 
_uint_1: 
	.quad 0x0000000000000001
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000
	.quad 0x0000000000000000


.global _uint_eq
_uint_eq: 
	eor x17, x17, x17  // clear result 
	/* Limbs 0 - 3 */
	ldp x2, x3, [x0, #0]  // load A 
	ldp x4, x5, [x0, #16]  // load A 
	ldp x6, x7, [x1, #0]  // load B 
	ldp x8, x9, [x1, #16]  // load B 
	eor x10, x2, x6  // 0 if equal 
	eor x11, x3, x7  // 0 if equal 
	orr x14, x10, x11  // accumulate 
	eor x12, x4, x8  // 0 if equal 
	eor x13, x5, x9  // 0 if equal 
	orr x15, x12, x13  // accumulate 
	orr x16, x14, x15  // accumulate intermediate together 
	orr x17, x17, x16  // accumulate in result 
	/* Limbs 4 - 7 */
	ldp x2, x3, [x0, #32]  // load A 
	ldp x4, x5, [x0, #48]  // load A 
	ldp x6, x7, [x1, #32]  // load B 
	ldp x8, x9, [x1, #48]  // load B 
	eor x10, x2, x6  // 0 if equal 
	eor x11, x3, x7  // 0 if equal 
	orr x14, x10, x11  // accumulate 
	eor x12, x4, x8  // 0 if equal 
	eor x13, x5, x9  // 0 if equal 
	orr x15, x12, x13  // accumulate 
	orr x16, x14, x15  // accumulate intermediate together 
	orr x17, x17, x16  // accumulate in result 
	/* Limbs 8 - 11 */
	ldp x2, x3, [x0, #64]  // load A 
	ldp x4, x5, [x0, #80]  // load A 
	ldp x6, x7, [x1, #64]  // load B 
	ldp x8, x9, [x1, #80]  // load B 
	eor x10, x2, x6  // 0 if equal 
	eor x11, x3, x7  // 0 if equal 
	orr x14, x10, x11  // accumulate 
	eor x12, x4, x8  // 0 if equal 
	eor x13, x5, x9  // 0 if equal 
	orr x15, x12, x13  // accumulate 
	orr x16, x14, x15  // accumulate intermediate together 
	orr x17, x17, x16  // accumulate in result 
	/* Limbs 12 - 15 */
	ldp x2, x3, [x0, #96]  // load A 
	ldp x4, x5, [x0, #112]  // load A 
	ldp x6, x7, [x1, #96]  // load B 
	ldp x8, x9, [x1, #112]  // load B 
	eor x10, x2, x6  // 0 if equal 
	eor x11, x3, x7  // 0 if equal 
	orr x14, x10, x11  // accumulate 
	eor x12, x4, x8  // 0 if equal 
	eor x13, x5, x9  // 0 if equal 
	orr x15, x12, x13  // accumulate 
	orr x16, x14, x15  // accumulate intermediate together 
	orr x17, x17, x16  // accumulate in result 
	cmp x17, #0 // local not of acc result 
	cset w0, eq // set result to 1 if equal 
	ret 

.global _uint_set
_uint_set: 
	stp x1, xzr, [x0, #0]  // store x1 and zero 
	stp xzr, xzr, [x0, #16]  
	stp xzr, xzr, [x0, #32]  
	stp xzr, xzr, [x0, #48]  
	stp xzr, xzr, [x0, #64]  
	stp xzr, xzr, [x0, #80]  
	stp xzr, xzr, [x0, #96]  
	stp xzr, xzr, [x0, #112]  
	ret 

	/* get position most significant non-zero bit */
.global _uint_len
_uint_len: 
	mov x7, #0  // initialize final result 
	mov x17, #64  // init x17 
	/* Limbs 0 - 1 */
	ldp x2, x3, [x0, #0]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, x17, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, x17, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #0 // add limb offsets
	add x5, x5, #64 
	cmp x4, 0 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #8 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* Limbs 2 - 3 */
	ldp x2, x3, [x0, #16]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, x17, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, x17, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #128 // add limb offsets
	add x5, x5, #192 
	cmp x4, 16 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #24 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* Limbs 4 - 5 */
	ldp x2, x3, [x0, #32]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, x17, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, x17, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #256 // add limb offsets
	add x5, x5, #320 
	cmp x4, 32 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #40 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* Limbs 6 - 7 */
	ldp x2, x3, [x0, #48]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, x17, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, x17, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #384 // add limb offsets
	add x5, x5, #448 
	cmp x4, 48 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #56 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* Limbs 8 - 9 */
	ldp x2, x3, [x0, #64]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, x17, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, x17, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #512 // add limb offsets
	add x5, x5, #576 
	cmp x4, 64 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #72 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* Limbs 10 - 11 */
	ldp x2, x3, [x0, #80]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, x17, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, x17, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #640 // add limb offsets
	add x5, x5, #704 
	cmp x4, 80 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #88 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* Limbs 12 - 13 */
	ldp x2, x3, [x0, #96]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, x17, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, x17, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #768 // add limb offsets
	add x5, x5, #832 
	cmp x4, 96 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #104 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* Limbs 14 - 15 */
	ldp x2, x3, [x0, #112]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, x17, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, x17, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #896 // add limb offsets
	add x5, x5, #960 
	cmp x4, 112 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #120 
	csel x7, x5, x7, ne // if equal keep, else new result

	mov x0, x7  // return final offset 
	ret 

	/* 
 x1 = position of bit 0 -1022 
 x0 = number array */
.global _uint_bit
_uint_bit: 
	lsr x3, x1, #6  // divide by 64 to get the index of the limb of the position 
	lsl x3, x3, #3  // *8 for actuall offset 

	and x5, x1, #63  // 63 = 0b0000000000...111111 so it does modulo 64 
	ldr x3, [x0, x3] // load the limb
	lsr x3, x3, x5  // Right shift by x0%64 to bring the bit of interest to the least significant position 
	and x0, x3, #1  // and with 1 to get bit result 
	ret 

/* 
 [x0] = [x1] + [x2] carry into x0 
*/
.global _uint_add3
_uint_add3: 
	/* Limbs 0 - 3 */
	ldp x3, x4, [x1, #0]  // load A 
	ldp x5, x6, [x1, #16]  // load A 
	ldp x7, x8, [x2, #0]  // load B 
	ldp x9, x10, [x2, #16]  // load B 
	adds x11, x3, x7  // First time without carry 
	adcs x12, x4, x8  // adcs second limb 
	adcs x13, x5, x9  // adcs third limb 
	adcs x14, x6, x10  // adcs fourth limb 
	stp x11, x12, [x0, #0]  // store result 
	stp x13, x14, [x0, #16]  // store result 

	/* Limbs 4 - 7 */
	ldp x3, x4, [x1, #32]  // load A 
	ldp x5, x6, [x1, #48]  // load A 
	ldp x7, x8, [x2, #32]  // load B 
	ldp x9, x10, [x2, #48]  // load B 
	adcs x11, x3, x7  // adcs first limb 
	adcs x12, x4, x8  // adcs second limb 
	adcs x13, x5, x9  // adcs third limb 
	adcs x14, x6, x10  // adcs fourth limb 
	stp x11, x12, [x0, #32]  // store result 
	stp x13, x14, [x0, #48]  // store result 

	/* Limbs 8 - 11 */
	ldp x3, x4, [x1, #64]  // load A 
	ldp x5, x6, [x1, #80]  // load A 
	ldp x7, x8, [x2, #64]  // load B 
	ldp x9, x10, [x2, #80]  // load B 
	adcs x11, x3, x7  // adcs first limb 
	adcs x12, x4, x8  // adcs second limb 
	adcs x13, x5, x9  // adcs third limb 
	adcs x14, x6, x10  // adcs fourth limb 
	stp x11, x12, [x0, #64]  // store result 
	stp x13, x14, [x0, #80]  // store result 

	/* Limbs 12 - 15 */
	ldp x3, x4, [x1, #96]  // load A 
	ldp x5, x6, [x1, #112]  // load A 
	ldp x7, x8, [x2, #96]  // load B 
	ldp x9, x10, [x2, #112]  // load B 
	adcs x11, x3, x7  // adcs first limb 
	adcs x12, x4, x8  // adcs second limb 
	adcs x13, x5, x9  // adcs third limb 
	adcs x14, x6, x10  // adcs fourth limb 
	stp x11, x12, [x0, #96]  // store result 
	stp x13, x14, [x0, #112]  // store result 

	adcs x0, xzr, xzr  // returing final carry 
	ret 

	/* x0 = x1 - x2, x0 = carry */
.global _uint_sub3
_uint_sub3: 
	/* Limbs 0 - 3 */
	ldp x3, x4, [x1, #0]  // load A 
	ldp x5, x6, [x1, #16]  // load A 
	ldp x7, x8, [x2, #0]  // load B 
	ldp x9, x10, [x2, #16]  // load B 
	subs x11, x3, x7  // First time without carry 
	sbcs x12, x4, x8  // sbcs second limb 
	sbcs x13, x5, x9  // sbcs third limb 
	sbcs x14, x6, x10  // sbcs fourth limb 
	stp x11, x12, [x0, #0]  // store result 
	stp x13, x14, [x0, #16]  // store result 

	/* Limbs 4 - 7 */
	ldp x3, x4, [x1, #32]  // load A 
	ldp x5, x6, [x1, #48]  // load A 
	ldp x7, x8, [x2, #32]  // load B 
	ldp x9, x10, [x2, #48]  // load B 
	sbcs x11, x3, x7  // sbcs first limb 
	sbcs x12, x4, x8  // sbcs second limb 
	sbcs x13, x5, x9  // sbcs third limb 
	sbcs x14, x6, x10  // sbcs fourth limb 
	stp x11, x12, [x0, #32]  // store result 
	stp x13, x14, [x0, #48]  // store result 

	/* Limbs 8 - 11 */
	ldp x3, x4, [x1, #64]  // load A 
	ldp x5, x6, [x1, #80]  // load A 
	ldp x7, x8, [x2, #64]  // load B 
	ldp x9, x10, [x2, #80]  // load B 
	sbcs x11, x3, x7  // sbcs first limb 
	sbcs x12, x4, x8  // sbcs second limb 
	sbcs x13, x5, x9  // sbcs third limb 
	sbcs x14, x6, x10  // sbcs fourth limb 
	stp x11, x12, [x0, #64]  // store result 
	stp x13, x14, [x0, #80]  // store result 

	/* Limbs 12 - 15 */
	ldp x3, x4, [x1, #96]  // load A 
	ldp x5, x6, [x1, #112]  // load A 
	ldp x7, x8, [x2, #96]  // load B 
	ldp x9, x10, [x2, #112]  // load B 
	sbcs x11, x3, x7  // sbcs first limb 
	sbcs x12, x4, x8  // sbcs second limb 
	sbcs x13, x5, x9  // sbcs third limb 
	sbcs x14, x6, x10  // sbcs fourth limb 
	stp x11, x12, [x0, #96]  // store result 
	stp x13, x14, [x0, #112]  // store result 

	sbcs x0, xzr, xzr // returing final carry 
	ret 

	/* [x0] = [x1] * x2 , x2 = direct value, we ignore last carry */
.global _uint_mul3_64
_uint_mul3_64: 
	adds x15, xzr, xzr  // initialize carry and set flags 
	/* Limbs 0 - 3 */
	ldp x3, x4, [x1, #0]  // load A 
	ldp x5, x6, [x1, #16]  // load A 
	mul x7, x3, x2  // C0 
	umulh x8, x3, x2  // C1 
	mul x9, x4, x2  // C1 
	umulh x10, x4, x2  // C2 
	mul x11, x5, x2  // C2 
	umulh x12, x5, x2  // C3 
	mul x13, x6, x2  // C3 
	umulh x14, x6, x2  // C4 
	adcs x7, x7, x15  // add carry from previous 
	adcs x8, x8, x9  // C1 
	adcs x10, x10, x11  // C2 
	adcs x12, x12, x13  // C3 
	adcs x15, xzr, x14  // last umul into carry reg 

	stp x7, x8, [x0, #0]  // store C0 and C1 
	stp x10, x12, [x0, #16]  // store C2 and C3 

	/* Limbs 4 - 7 */
	ldp x3, x4, [x1, #32]  // load A 
	ldp x5, x6, [x1, #48]  // load A 
	mul x7, x3, x2  // C4 
	umulh x8, x3, x2  // C5 
	mul x9, x4, x2  // C5 
	umulh x10, x4, x2  // C6 
	mul x11, x5, x2  // C6 
	umulh x12, x5, x2  // C7 
	mul x13, x6, x2  // C7 
	umulh x14, x6, x2  // C8 
	adcs x7, x7, x15  // add carry from previous 
	adcs x8, x8, x9  // C5 
	adcs x10, x10, x11  // C6 
	adcs x12, x12, x13  // C7 
	adcs x15, xzr, x14  // last umul into carry reg 

	stp x7, x8, [x0, #32]  // store C4 and C5 
	stp x10, x12, [x0, #48]  // store C6 and C7 

	/* Limbs 8 - 11 */
	ldp x3, x4, [x1, #64]  // load A 
	ldp x5, x6, [x1, #80]  // load A 
	mul x7, x3, x2  // C8 
	umulh x8, x3, x2  // C9 
	mul x9, x4, x2  // C9 
	umulh x10, x4, x2  // C10 
	mul x11, x5, x2  // C10 
	umulh x12, x5, x2  // C11 
	mul x13, x6, x2  // C11 
	umulh x14, x6, x2  // C12 
	adcs x7, x7, x15  // add carry from previous 
	adcs x8, x8, x9  // C9 
	adcs x10, x10, x11  // C10 
	adcs x12, x12, x13  // C11 
	adcs x15, xzr, x14  // last umul into carry reg 

	stp x7, x8, [x0, #64]  // store C8 and C9 
	stp x10, x12, [x0, #80]  // store C10 and C11 

	/* Limbs 12 - 15 */
	ldp x3, x4, [x1, #96]  // load A 
	ldp x5, x6, [x1, #112]  // load A 
	mul x7, x3, x2  // C12 
	umulh x8, x3, x2  // C13 
	mul x9, x4, x2  // C13 
	umulh x10, x4, x2  // C14 
	mul x11, x5, x2  // C14 
	umulh x12, x5, x2  // C15 
	mul x13, x6, x2  // C15 
	umulh x14, x6, x2  // C16 
	adcs x7, x7, x15  // add carry from previous 
	adcs x8, x8, x9  // C13 
	adcs x10, x10, x11  // C14 
	adcs x12, x12, x13  // C15 
	adcs x15, xzr, x14  // last umul into carry reg 

	stp x7, x8, [x0, #96]  // store C12 and C13 
	stp x10, x12, [x0, #112]  // store C14 and C15 

	ret 


	/* x0 = x0: place to store random number x1: uniformly distributed in (0,x1 */
.global _uint_random
_uint_random: 
	sub sp, sp, #32
	stp x0, x1, [sp, #0]
	str lr, [sp, #16]
	mov x0, x1  // copy x0 to x1 
	bl _uint_len
	mov x1, x0  // copy x0 to x1 
	lsr x3, x1, #3  // divide by 8 to get number of complete bytes 
	and x4, x1, #63  // get remainder bits 
	mov x1, x3  // copy complete bytes to x1 
	ldr x0, [sp, #0] // load resulta addr 
	bl _randombytes
	ldp x0, x1, [sp, #0]
	ldr lr, [sp, #16]
	add sp, sp, #32
	ret 

