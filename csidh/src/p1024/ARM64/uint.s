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
	orr x17, x17, x17  // clear result 
	/* iteration 0 */
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
	/* iteration 1 */
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
	/* iteration 2 */
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
	/* iteration 3 */
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
	/* iteration 4 */
	ldp x2, x3, [x0, #128]  // load A 
	ldp x4, x5, [x0, #144]  // load A 
	ldp x6, x7, [x1, #128]  // load B 
	ldp x8, x9, [x1, #144]  // load B 
	eor x10, x2, x6  // 0 if equal 
	eor x11, x3, x7  // 0 if equal 
	orr x14, x10, x11  // accumulate 
	eor x12, x4, x8  // 0 if equal 
	eor x13, x5, x9  // 0 if equal 
	orr x15, x12, x13  // accumulate 
	orr x16, x14, x15  // accumulate intermediate together 
	orr x17, x17, x16  // accumulate in result 
	/* iteration 5 */
	ldp x2, x3, [x0, #160]  // load A 
	ldp x4, x5, [x0, #176]  // load A 
	ldp x6, x7, [x1, #160]  // load B 
	ldp x8, x9, [x1, #176]  // load B 
	eor x10, x2, x6  // 0 if equal 
	eor x11, x3, x7  // 0 if equal 
	orr x14, x10, x11  // accumulate 
	eor x12, x4, x8  // 0 if equal 
	eor x13, x5, x9  // 0 if equal 
	orr x15, x12, x13  // accumulate 
	orr x16, x14, x15  // accumulate intermediate together 
	orr x17, x17, x16  // accumulate in result 
	/* iteration 6 */
	ldp x2, x3, [x0, #192]  // load A 
	ldp x4, x5, [x0, #208]  // load A 
	ldp x6, x7, [x1, #192]  // load B 
	ldp x8, x9, [x1, #208]  // load B 
	eor x10, x2, x6  // 0 if equal 
	eor x11, x3, x7  // 0 if equal 
	orr x14, x10, x11  // accumulate 
	eor x12, x4, x8  // 0 if equal 
	eor x13, x5, x9  // 0 if equal 
	orr x15, x12, x13  // accumulate 
	orr x16, x14, x15  // accumulate intermediate together 
	orr x17, x17, x16  // accumulate in result 
	/* iteration 7 */
	ldp x2, x3, [x0, #224]  // load A 
	ldp x4, x5, [x0, #240]  // load A 
	ldp x6, x7, [x1, #224]  // load B 
	ldp x8, x9, [x1, #240]  // load B 
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
	/* iteration 0 */
	ldp x2, x3, [x0, #0]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, #64, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, #64, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #0 // add limb offsets
	add x5, x5, #8 
	cmp x4, 0 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #8 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* iteration 1 */
	ldp x2, x3, [x0, #16]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, #64, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, #64, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #16 // add limb offsets
	add x5, x5, #24 
	cmp x4, 16 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #24 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* iteration 2 */
	ldp x2, x3, [x0, #32]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, #64, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, #64, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #32 // add limb offsets
	add x5, x5, #40 
	cmp x4, 32 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #40 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* iteration 3 */
	ldp x2, x3, [x0, #48]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, #64, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, #64, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #48 // add limb offsets
	add x5, x5, #56 
	cmp x4, 48 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #56 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* iteration 4 */
	ldp x2, x3, [x0, #64]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, #64, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, #64, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #64 // add limb offsets
	add x5, x5, #72 
	cmp x4, 64 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #72 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* iteration 5 */
	ldp x2, x3, [x0, #80]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, #64, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, #64, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #80 // add limb offsets
	add x5, x5, #88 
	cmp x4, 80 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #88 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* iteration 6 */
	ldp x2, x3, [x0, #96]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, #64, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, #64, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #96 // add limb offsets
	add x5, x5, #104 
	cmp x4, 96 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #104 
	csel x7, x5, x7, ne // if equal keep, else new result

	/* iteration 7 */
	ldp x2, x3, [x0, #112]  // load two limbs to ['x2', 'x3'] 
	clz x4, x2 // count leading zeros in first limb
	clz x5, x3 // count leading zeros in second limb
	sub x4, #64, x4 // subtract from 64 for position of first bit that is 1 or 0
	sub x5, #64, x5 // subtract from 64 for position of first bit that is 1 or 0
	add x4, x4, #112 // add limb offsets
	add x5, x5, #120 
	cmp x4, 112 // Now we compare if the limb offset equals the current offset (if this is the case there is no 0)
	csel x7, x4, x7, ne // if equal keep, else new result
	cmp x5, #120 
	csel x7, x5, x7, ne // if equal keep, else new result

	mov x0, x7  // return final offset 
	ret 

