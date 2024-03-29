/* DO Not edit generated by autogen */

.extern _fp_mul_counter.text

.align 4

.macro LOAD_8_WORD_NUMBER42, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, num_pointer
    LDP \reg1, \reg2, [\num_pointer,#0] 
    LDP \reg3, \reg4, [\num_pointer,#16]
    LDP \reg5, \reg6, [\num_pointer,#32]
    LDP \reg7, \reg8, [\num_pointer, #48]
.endm

.macro STORE_8_WORD_NUMBER42, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, destination_pointer
    STP \reg1, \reg2, [\destination_pointer,#0] 
    STP \reg3, \reg4, [\destination_pointer,#16]
    STP \reg5, \reg6, [\destination_pointer,#32]
    STP \reg7, \reg8, [\destination_pointer, #48]
.endm

.macro LOAD_511_PRIME42, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8
    adrp \reg8, _p@PAGE
    add \reg8, \reg8, _p@PAGEOFF
    LDP \reg1, \reg2, [\reg8, #0]
    LDP \reg3, \reg4, [\reg8, #16]
    LDP \reg5, \reg6, [\reg8, #32]
    LDP \reg7, \reg8, [\reg8, #48]
   
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


	/* [x0] = [x1]*[x2] */
.global _uint_mul_512x512
_uint_mul_512x512: 
	sub sp, sp, #96
	stp x19, x20, [sp, #0]
	stp x21, x22, [sp, #16]
	stp x23, x24, [sp, #32]
	stp x25, x26, [sp, #48]
	stp x27, x28, [sp, #64]
	str x30, [sp, #80]
	/* Load A and B */
	ldp x3, x4, [x0, #0]  
	ldp x11, x12, [x1, #0]  
	ldp x5, x6, [x0, #16]  
	ldp x13, x14, [x1, #16]  
	ldp x7, x8, [x0, #32]  
	ldp x15, x16, [x1, #32]  
	ldp x9, x10, [x0, #48]  
	ldp x17, x19, [x1, #48]  
	mov x28, xzr  
	adds x30, xzr, xzr  
	/* C0 */
	mul x20, x3, x11  // FREE_REGS[0] = A_REGS[0] mul B_REGS[0] 
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	str x28, [x2, #0]  
	mov x28, x30  
	mov x30, xzr  


	/* C1 */
	umulh x21, x3, x11  //  FREE_REGS[1] = A_REGS[0] umulh B_REGS[0] 
	mul x22, x3, x12  // FREE_REGS[2] = A_REGS[0] mul B_REGS[1] 
	mul x23, x4, x11  // FREE_REGS[3] = A_REGS[1] mul B_REGS[0] 
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	str x28, [x2, #8]  
	mov x28, x30  
	mov x30, xzr  


	/* C2 */
	umulh x24, x3, x12  //  FREE_REGS[4] = A_REGS[0] umulh B_REGS[1] 
	mul x25, x3, x13  // FREE_REGS[5] = A_REGS[0] mul B_REGS[2] 
	umulh x26, x4, x11  //  FREE_REGS[6] = A_REGS[1] umulh B_REGS[0] 
	mul x27, x4, x12  // FREE_REGS[7] = A_REGS[1] mul B_REGS[1] 
	mul x20, x5, x11  // FREE_REGS[0] = A_REGS[2] mul B_REGS[0] 
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	str x28, [x2, #16]  
	mov x28, x30  
	mov x30, xzr  


	/* C3 */
	umulh x21, x3, x13  //  FREE_REGS[1] = A_REGS[0] umulh B_REGS[2] 
	mul x22, x3, x14  // FREE_REGS[2] = A_REGS[0] mul B_REGS[3] 
	umulh x23, x4, x12  //  FREE_REGS[3] = A_REGS[1] umulh B_REGS[1] 
	mul x24, x4, x13  // FREE_REGS[4] = A_REGS[1] mul B_REGS[2] 
	umulh x25, x5, x11  //  FREE_REGS[5] = A_REGS[2] umulh B_REGS[0] 
	mul x26, x5, x12  // FREE_REGS[6] = A_REGS[2] mul B_REGS[1] 
	mul x27, x6, x11  // FREE_REGS[7] = A_REGS[3] mul B_REGS[0] 
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	str x28, [x2, #24]  
	mov x28, x30  
	mov x30, xzr  


	/* C4 */
	umulh x20, x3, x14  //  FREE_REGS[0] = A_REGS[0] umulh B_REGS[3] 
	mul x21, x3, x15  // FREE_REGS[1] = A_REGS[0] mul B_REGS[4] 
	umulh x22, x4, x13  //  FREE_REGS[2] = A_REGS[1] umulh B_REGS[2] 
	mul x23, x4, x14  // FREE_REGS[3] = A_REGS[1] mul B_REGS[3] 
	umulh x24, x5, x12  //  FREE_REGS[4] = A_REGS[2] umulh B_REGS[1] 
	mul x25, x5, x13  // FREE_REGS[5] = A_REGS[2] mul B_REGS[2] 
	umulh x26, x6, x11  //  FREE_REGS[6] = A_REGS[3] umulh B_REGS[0] 
	mul x27, x6, x12  // FREE_REGS[7] = A_REGS[3] mul B_REGS[1] 
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	mul x20, x7, x11  // FREE_REGS[0] = A_REGS[4] mul B_REGS[0] 
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	str x28, [x2, #32]  
	mov x28, x30  
	mov x30, xzr  


	/* C5 */
	umulh x21, x3, x15  //  FREE_REGS[1] = A_REGS[0] umulh B_REGS[4] 
	mul x22, x3, x16  // FREE_REGS[2] = A_REGS[0] mul B_REGS[5] 
	umulh x23, x4, x14  //  FREE_REGS[3] = A_REGS[1] umulh B_REGS[3] 
	mul x24, x4, x15  // FREE_REGS[4] = A_REGS[1] mul B_REGS[4] 
	umulh x25, x5, x13  //  FREE_REGS[5] = A_REGS[2] umulh B_REGS[2] 
	mul x26, x5, x14  // FREE_REGS[6] = A_REGS[2] mul B_REGS[3] 
	umulh x27, x6, x12  //  FREE_REGS[7] = A_REGS[3] umulh B_REGS[1] 
	mul x20, x6, x13  // FREE_REGS[0] = A_REGS[3] mul B_REGS[2] 
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	umulh x21, x7, x11  //  FREE_REGS[1] = A_REGS[4] umulh B_REGS[0] 
	mul x22, x7, x12  // FREE_REGS[2] = A_REGS[4] mul B_REGS[1] 
	mul x23, x8, x11  // FREE_REGS[3] = A_REGS[5] mul B_REGS[0] 
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	str x28, [x2, #40]  
	mov x28, x30  
	mov x30, xzr  


	/* C6 */
	umulh x24, x3, x16  //  FREE_REGS[4] = A_REGS[0] umulh B_REGS[5] 
	mul x25, x3, x17  // FREE_REGS[5] = A_REGS[0] mul B_REGS[6] 
	umulh x26, x4, x15  //  FREE_REGS[6] = A_REGS[1] umulh B_REGS[4] 
	mul x27, x4, x16  // FREE_REGS[7] = A_REGS[1] mul B_REGS[5] 
	umulh x20, x5, x14  //  FREE_REGS[0] = A_REGS[2] umulh B_REGS[3] 
	mul x21, x5, x15  // FREE_REGS[1] = A_REGS[2] mul B_REGS[4] 
	umulh x22, x6, x13  //  FREE_REGS[2] = A_REGS[3] umulh B_REGS[2] 
	mul x23, x6, x14  // FREE_REGS[3] = A_REGS[3] mul B_REGS[3] 
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	umulh x24, x7, x12  //  FREE_REGS[4] = A_REGS[4] umulh B_REGS[1] 
	mul x25, x7, x13  // FREE_REGS[5] = A_REGS[4] mul B_REGS[2] 
	umulh x26, x8, x11  //  FREE_REGS[6] = A_REGS[5] umulh B_REGS[0] 
	mul x27, x8, x12  // FREE_REGS[7] = A_REGS[5] mul B_REGS[1] 
	mul x20, x9, x11  // FREE_REGS[0] = A_REGS[6] mul B_REGS[0] 
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	str x28, [x2, #48]  
	mov x28, x30  
	mov x30, xzr  


	/* C7 */
	umulh x21, x3, x17  //  FREE_REGS[1] = A_REGS[0] umulh B_REGS[6] 
	mul x22, x3, x19  // FREE_REGS[2] = A_REGS[0] mul B_REGS[7] 
	umulh x23, x4, x16  //  FREE_REGS[3] = A_REGS[1] umulh B_REGS[5] 
	mul x24, x4, x17  // FREE_REGS[4] = A_REGS[1] mul B_REGS[6] 
	umulh x25, x5, x15  //  FREE_REGS[5] = A_REGS[2] umulh B_REGS[4] 
	mul x26, x5, x16  // FREE_REGS[6] = A_REGS[2] mul B_REGS[5] 
	umulh x27, x6, x14  //  FREE_REGS[7] = A_REGS[3] umulh B_REGS[3] 
	mul x20, x6, x15  // FREE_REGS[0] = A_REGS[3] mul B_REGS[4] 
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	umulh x21, x7, x13  //  FREE_REGS[1] = A_REGS[4] umulh B_REGS[2] 
	mul x22, x7, x14  // FREE_REGS[2] = A_REGS[4] mul B_REGS[3] 
	umulh x23, x8, x12  //  FREE_REGS[3] = A_REGS[5] umulh B_REGS[1] 
	mul x24, x8, x13  // FREE_REGS[4] = A_REGS[5] mul B_REGS[2] 
	umulh x25, x9, x11  //  FREE_REGS[5] = A_REGS[6] umulh B_REGS[0] 
	mul x26, x9, x12  // FREE_REGS[6] = A_REGS[6] mul B_REGS[1] 
	mul x27, x10, x11  // FREE_REGS[7] = A_REGS[7] mul B_REGS[0] 
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	str x28, [x2, #56]  
	mov x28, x30  
	mov x30, xzr  


	/* C8 */
	umulh x20, x3, x19  //  FREE_REGS[0] = A_REGS[0] umulh B_REGS[7] 
	umulh x21, x4, x17  //  FREE_REGS[1] = A_REGS[1] umulh B_REGS[6] 
	mul x22, x4, x19  // FREE_REGS[2] = A_REGS[1] mul B_REGS[7] 
	umulh x23, x5, x16  //  FREE_REGS[3] = A_REGS[2] umulh B_REGS[5] 
	mul x24, x5, x17  // FREE_REGS[4] = A_REGS[2] mul B_REGS[6] 
	umulh x25, x6, x15  //  FREE_REGS[5] = A_REGS[3] umulh B_REGS[4] 
	mul x26, x6, x16  // FREE_REGS[6] = A_REGS[3] mul B_REGS[5] 
	umulh x27, x7, x14  //  FREE_REGS[7] = A_REGS[4] umulh B_REGS[3] 
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	mul x20, x7, x15  // FREE_REGS[0] = A_REGS[4] mul B_REGS[4] 
	umulh x21, x8, x13  //  FREE_REGS[1] = A_REGS[5] umulh B_REGS[2] 
	mul x22, x8, x14  // FREE_REGS[2] = A_REGS[5] mul B_REGS[3] 
	umulh x23, x9, x12  //  FREE_REGS[3] = A_REGS[6] umulh B_REGS[1] 
	mul x24, x9, x13  // FREE_REGS[4] = A_REGS[6] mul B_REGS[2] 
	umulh x25, x10, x11  //  FREE_REGS[5] = A_REGS[7] umulh B_REGS[0] 
	mul x26, x10, x12  // FREE_REGS[6] = A_REGS[7] mul B_REGS[1] 
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	str x28, [x2, #64]  
	mov x28, x30  
	mov x30, xzr  


	/* C9 */
	umulh x27, x4, x19  //  FREE_REGS[7] = A_REGS[1] umulh B_REGS[7] 
	umulh x20, x5, x17  //  FREE_REGS[0] = A_REGS[2] umulh B_REGS[6] 
	mul x21, x5, x19  // FREE_REGS[1] = A_REGS[2] mul B_REGS[7] 
	umulh x22, x6, x16  //  FREE_REGS[2] = A_REGS[3] umulh B_REGS[5] 
	mul x23, x6, x17  // FREE_REGS[3] = A_REGS[3] mul B_REGS[6] 
	umulh x24, x7, x15  //  FREE_REGS[4] = A_REGS[4] umulh B_REGS[4] 
	mul x25, x7, x16  // FREE_REGS[5] = A_REGS[4] mul B_REGS[5] 
	umulh x26, x8, x14  //  FREE_REGS[6] = A_REGS[5] umulh B_REGS[3] 
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	mul x27, x8, x15  // FREE_REGS[7] = A_REGS[5] mul B_REGS[4] 
	umulh x20, x9, x13  //  FREE_REGS[0] = A_REGS[6] umulh B_REGS[2] 
	mul x21, x9, x14  // FREE_REGS[1] = A_REGS[6] mul B_REGS[3] 
	umulh x22, x10, x12  //  FREE_REGS[2] = A_REGS[7] umulh B_REGS[1] 
	mul x23, x10, x13  // FREE_REGS[3] = A_REGS[7] mul B_REGS[2] 
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	str x28, [x2, #72]  
	mov x28, x30  
	mov x30, xzr  


	/* C10 */
	umulh x24, x5, x19  //  FREE_REGS[4] = A_REGS[2] umulh B_REGS[7] 
	umulh x25, x6, x17  //  FREE_REGS[5] = A_REGS[3] umulh B_REGS[6] 
	mul x26, x6, x19  // FREE_REGS[6] = A_REGS[3] mul B_REGS[7] 
	umulh x27, x7, x16  //  FREE_REGS[7] = A_REGS[4] umulh B_REGS[5] 
	mul x20, x7, x17  // FREE_REGS[0] = A_REGS[4] mul B_REGS[6] 
	umulh x21, x8, x15  //  FREE_REGS[1] = A_REGS[5] umulh B_REGS[4] 
	mul x22, x8, x16  // FREE_REGS[2] = A_REGS[5] mul B_REGS[5] 
	umulh x23, x9, x14  //  FREE_REGS[3] = A_REGS[6] umulh B_REGS[3] 
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	mul x24, x9, x15  // FREE_REGS[4] = A_REGS[6] mul B_REGS[4] 
	umulh x25, x10, x13  //  FREE_REGS[5] = A_REGS[7] umulh B_REGS[2] 
	mul x26, x10, x14  // FREE_REGS[6] = A_REGS[7] mul B_REGS[3] 
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	str x28, [x2, #80]  
	mov x28, x30  
	mov x30, xzr  


	/* C11 */
	umulh x27, x6, x19  //  FREE_REGS[7] = A_REGS[3] umulh B_REGS[7] 
	umulh x20, x7, x17  //  FREE_REGS[0] = A_REGS[4] umulh B_REGS[6] 
	mul x21, x7, x19  // FREE_REGS[1] = A_REGS[4] mul B_REGS[7] 
	umulh x22, x8, x16  //  FREE_REGS[2] = A_REGS[5] umulh B_REGS[5] 
	mul x23, x8, x17  // FREE_REGS[3] = A_REGS[5] mul B_REGS[6] 
	umulh x24, x9, x15  //  FREE_REGS[4] = A_REGS[6] umulh B_REGS[4] 
	mul x25, x9, x16  // FREE_REGS[5] = A_REGS[6] mul B_REGS[5] 
	umulh x26, x10, x14  //  FREE_REGS[6] = A_REGS[7] umulh B_REGS[3] 
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	mul x27, x10, x15  // FREE_REGS[7] = A_REGS[7] mul B_REGS[4] 
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	str x28, [x2, #88]  
	mov x28, x30  
	mov x30, xzr  


	/* C12 */
	umulh x20, x7, x19  //  FREE_REGS[0] = A_REGS[4] umulh B_REGS[7] 
	umulh x21, x8, x17  //  FREE_REGS[1] = A_REGS[5] umulh B_REGS[6] 
	mul x22, x8, x19  // FREE_REGS[2] = A_REGS[5] mul B_REGS[7] 
	umulh x23, x9, x16  //  FREE_REGS[3] = A_REGS[6] umulh B_REGS[5] 
	mul x24, x9, x17  // FREE_REGS[4] = A_REGS[6] mul B_REGS[6] 
	umulh x25, x10, x15  //  FREE_REGS[5] = A_REGS[7] umulh B_REGS[4] 
	mul x26, x10, x16  // FREE_REGS[6] = A_REGS[7] mul B_REGS[5] 
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	str x28, [x2, #96]  
	mov x28, x30  
	mov x30, xzr  


	/* C13 */
	umulh x27, x8, x19  //  FREE_REGS[7] = A_REGS[5] umulh B_REGS[7] 
	umulh x20, x9, x17  //  FREE_REGS[0] = A_REGS[6] umulh B_REGS[6] 
	mul x21, x9, x19  // FREE_REGS[1] = A_REGS[6] mul B_REGS[7] 
	umulh x22, x10, x16  //  FREE_REGS[2] = A_REGS[7] umulh B_REGS[5] 
	mul x23, x10, x17  // FREE_REGS[3] = A_REGS[7] mul B_REGS[6] 
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	adcs x28, x28, x20  
	adcs x30, x30, xzr  
	adcs x28, x28, x21  
	adcs x30, x30, xzr  
	adcs x28, x28, x22  
	adcs x30, x30, xzr  
	adcs x28, x28, x23  
	adcs x30, x30, xzr  
	str x28, [x2, #104]  
	mov x28, x30  
	mov x30, xzr  


	/* C14 */
	umulh x24, x9, x19  //  FREE_REGS[4] = A_REGS[6] umulh B_REGS[7] 
	umulh x25, x10, x17  //  FREE_REGS[5] = A_REGS[7] umulh B_REGS[6] 
	mul x26, x10, x19  // FREE_REGS[6] = A_REGS[7] mul B_REGS[7] 
	adcs x28, x28, x24  
	adcs x30, x30, xzr  
	adcs x28, x28, x25  
	adcs x30, x30, xzr  
	adcs x28, x28, x26  
	adcs x30, x30, xzr  
	str x28, [x2, #112]  
	mov x28, x30  
	mov x30, xzr  


	/* C15 */
	umulh x27, x10, x19  //  FREE_REGS[7] = A_REGS[7] umulh B_REGS[7] 
	adcs x28, x28, x27  
	adcs x30, x30, xzr  
	str x28, [x2, #120]  
	mov x28, x30  
	mov x30, xzr  


	ldp x19, x20, [sp, #0]
	ldp x21, x22, [sp, #16]
	ldp x23, x24, [sp, #32]
	ldp x25, x26, [sp, #48]
	ldp x27, x28, [sp, #64]
	ldr x30, [sp, #80]
	add sp, sp, #96
	ret


.global _fp_mul3
_fp_mul3:
    adrp x3, _fp_mul_counter@PAGE
    add x3, x3, _fp_mul_counter@PAGEOFF
    ldr x3, [x3]
    cbz x3, 0f
    ldr x4, [x3]
    add x4, x4, #1
    str x4, [x3]
    0:
    sub sp, sp, #224 // make space in the stack for 56 words
    stp lr, x0, [sp, #0] // store lr and result address
    stp x19, x20, [sp, #16] //store x19 and x20 to avoid segmentation fault
    stp x21, x22, [sp, #32] //store x21 and x22 to avoid segmentation fault

    mov x0, x2 // Move x2 to x0 for multiplication
    add x2, sp, #64 // result for mul = stack address + 16 + (16+8*16) words
    bl _uint_mul_512x512 // x2 = x0 * x1
    mov x0, x2 // copy result address of mul to x0 (this points to stack + 64)
    ldr x1, [sp, #8] // load back initial result address to x1
    bl _monte_reduce
    ldp lr, x0, [sp, #0] // get back lr
    ldp x19, x20, [sp, #16] //get back x19 - x22
    ldp x21, x22, [sp, #32]

    add sp, sp, #224 //give back the stack
    ret



/*
Input: 
    a such that 0 <= a < p^2
    R = 2^256
    mu_big = -p^(-1) mod R
Output: 
    C ≡ a*R^(−1) mod p such that 0 ≤ C < p
    Operation: c[x1] = a [x0] mod p

*/
_monte_reduce:
    // Make place in the stack for
    sub sp, sp, #512
    stp lr, x1, [sp, #0] // store lr and result address
    str x0, [sp, #16] // store adress of a

    // a mod R = Lower 8 words of a
    // load mu into x1 
    adrp x1, _mu@PAGE //get address of mu
    add x1, x1, _mu@PAGEOFF //add offset of mu
    //add  x1, x1, :lo12:mu aah, this was unnecessary then :) smart move
    add x2, sp, #24 // result of multiplication 16 words -> sp #24 - sp# 152
    // mu [x1] * ( a [x0] mod R )
    bl _uint_mul_512x512
    mov x1, x2 // copy result address to x1
    // q = lower 8 words of x1
    // C ← (a + p*q)/R
    // x0 = p
    adrp x0, _p@PAGE
    add x0, x0, _p@PAGEOFF
    add x2, sp, #152 // result of multiplication p*q 16 words from sp#152-280
    bl _uint_mul_512x512
    mov x0, x2 // x0 = p*q
    ldr x1, [sp, #16] // load address of a into x1 
    add x2, sp, #280 // result again 16 words from sp #280-408
    bl _add2_16_words
    // Result in higher 8 words of x2
    add x2, x2, #64 // 
    // If C >= p then C = C - p
    LOAD_8_WORD_NUMBER42 x3, x4, x5, x6, x7, x8, x9, x10, x2
    LOAD_511_PRIME42 x12, x13, x14, x15, x16, x17, x19, x20
    
    //Subtract Prime from a + b into register x3-x11, not(carry)
    SUBS x3, x3, x12
    SBCS x4, x4, x13
    SBCS x5, x5, x14
    SBCS x6, x6, x15
    SBCS x7, x7, x16
    SBCS x8, x8, x17
    SBCS x9, x9, x19
    SBCS x10, x10, x20
    //SBCS x11, x11, xzr // this is the error.
    // The carry into x21
    SBCS x21, xzr, xzr

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
    ADCS x10, x10, x20

    // load result address
    ldr x1, [sp, #8]
    STORE_8_WORD_NUMBER42 x3, x4, x5, x6, x7, x8, x9, x10, x1    
    ldr lr, [sp, #0]
    add sp, sp, #512
    ret


/*  
Operation: c[x2] = a[x0] + b[x1]
a, b, c = 16 words
not defined in fp.c
*/
_add2_16_words:
    // Word 0
    LDR x4, [x0]          // Load word 0 from a
    LDR x5, [x1]          // Load word 0 from b
    ADDS x6, x4, x5       // Add the two words, set flags
    STR x6, [x2]          // Store the result word 0 to c

    // Word 1
    LDR x4, [x0, #8]         
    LDR x5, [x1, #8]      
    ADCS x6, x4, x5       
    STR x6, [x2, #8]      
    
    // Word 2
    LDR x4, [x0, #16]     
    LDR x5, [x1, #16]     
    ADCS x6, x4, x5       
    STR x6, [x2, #16]

    // Word 3
    LDR x4, [x0, #24]
    LDR x5, [x1, #24]
    ADCS x6, x4, x5
    STR x6, [x2, #24]

    // Word 4
    LDR x4, [x0, #32]
    LDR x5, [x1, #32]
    ADCS x6, x4, x5
    STR x6, [x2, #32]

    // Word 5
    LDR x4, [x0, #40]
    LDR x5, [x1, #40]
    ADCS x6, x4, x5
    STR x6, [x2, #40]

    // Word 6
    LDR x4, [x0, #48]
    LDR x5, [x1, #48]
    ADCS x6, x4, x5
    STR x6, [x2, #48]

    // Word 7
    LDR x4, [x0, #56]
    LDR x5, [x1, #56]
    ADCS x6, x4, x5
    STR x6, [x2, #56]

    // Word 8
    LDR x4, [x0, #64]
    LDR x5, [x1, #64]
    ADCS x6, x4, x5
    STR x6, [x2, #64]

    // Word 9
    LDR x4, [x0, #72]
    LDR x5, [x1, #72]
    ADCS x6, x4, x5
    STR x6, [x2, #72]

    // Word 10
    LDR x4, [x0, #80]
    LDR x5, [x1, #80]
    ADCS x6, x4, x5
    STR x6, [x2, #80]

    // Word 11
    LDR x4, [x0, #88]
    LDR x5, [x1, #88]
    ADCS x6, x4, x5
    STR x6, [x2, #88]

    // Word 12
    LDR x4, [x0, #96]
    LDR x5, [x1, #96]
    ADCS x6, x4, x5
    STR x6, [x2, #96]

    // Word 13
    LDR x4, [x0, #104]
    LDR x5, [x1, #104]
    ADCS x6, x4, x5
    STR x6, [x2, #104]

    // Word 14
    LDR x4, [x0, #112]
    LDR x5, [x1, #112]
    ADCS x6, x4, x5
    STR x6, [x2, #112]

    // Word 15
    LDR x4, [x0, #120]
    LDR x5, [x1, #120]
    ADCS x6, x4, x5
    STR x6, [x2, #120]
    ret
