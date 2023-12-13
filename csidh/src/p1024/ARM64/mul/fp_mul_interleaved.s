/* DO EDIT! generated by autogen */
.extern _inv_min_p_mod_r
.extern _p
.extern _reduce_once

.text
.align 4
/*
 [C_ADR]+1 = [C_ADR] + [B_ADR] * AI   
*/ 
.macro MUL_16x1, AI, B_ADR, C_ADR, CARRY_REG, C0, C1, C2, C3, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15 
	adds \CARRY_REG, xzr, xzr  // CARRY_REG = 0 

	/* LIMBS C0-C3 */
	ldp \T0, \T1, [\B_ADR, #0]  // Load B 
	ldp \C0, \C1, [\C_ADR, #0]  // Load C 
	ldp \T2, \T3, [\B_ADR, #16]  // Load B 
	ldp \C2, \C3, [\C_ADR, #16]  // Load C 

	mul \T8, \T0, \AI  
	umulh \T9, \T0, \AI  
	mul \T10, \T1, \AI  
	umulh \T11, \T1, \AI  
	mul \T12, \T2, \AI  
	umulh \T13, \T2, \AI  
	mul \T14, \T3, \AI  
	umulh \T15, \T3, \AI  

	adcs \C0, \C0, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C0, \C0, \T8  // add C0 

	adcs \C1, \C1, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C1, \C1, \T9  // add C1 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C1, \C1, \T10  // add T 

	adcs \C2, \C2, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C2, \C2, \T11  // add C2 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C2, \C2, \T12  // add T 

	adcs \C3, \C3, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C3, \C3, \T13  // add C3 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C3, \C3, \T14  // add T 

	adcs \CARRY_REG, \CARRY_REG, \T15  
	stp \C0, \C1, [\C_ADR, #0]  // Store C 
	stp \T2, \T3, [\C_ADR, #16]  

	/* LIMBS C4-C7 */
	ldp \T0, \T1, [\B_ADR, #32]  // Load B 
	ldp \C0, \C1, [\C_ADR, #32]  // Load C 
	ldp \T2, \T3, [\B_ADR, #48]  // Load B 
	ldp \C2, \C3, [\C_ADR, #48]  // Load C 

	mul \T8, \T0, \AI  
	umulh \T9, \T0, \AI  
	mul \T10, \T1, \AI  
	umulh \T11, \T1, \AI  
	mul \T12, \T2, \AI  
	umulh \T13, \T2, \AI  
	mul \T14, \T3, \AI  
	umulh \T15, \T3, \AI  

	adcs \C0, \C0, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C0, \C0, \T8  // add C4 

	adcs \C1, \C1, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C1, \C1, \T9  // add C5 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C1, \C1, \T10  // add T 

	adcs \C2, \C2, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C2, \C2, \T11  // add C6 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C2, \C2, \T12  // add T 

	adcs \C3, \C3, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C3, \C3, \T13  // add C7 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C3, \C3, \T14  // add T 

	adcs \CARRY_REG, \CARRY_REG, \T15  
	stp \C0, \C1, [\C_ADR, #32]  // Store C 
	stp \T2, \T3, [\C_ADR, #48]  

	/* LIMBS C8-C11 */
	ldp \T0, \T1, [\B_ADR, #64]  // Load B 
	ldp \C0, \C1, [\C_ADR, #64]  // Load C 
	ldp \T2, \T3, [\B_ADR, #80]  // Load B 
	ldp \C2, \C3, [\C_ADR, #80]  // Load C 

	mul \T8, \T0, \AI  
	umulh \T9, \T0, \AI  
	mul \T10, \T1, \AI  
	umulh \T11, \T1, \AI  
	mul \T12, \T2, \AI  
	umulh \T13, \T2, \AI  
	mul \T14, \T3, \AI  
	umulh \T15, \T3, \AI  

	adcs \C0, \C0, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C0, \C0, \T8  // add C8 

	adcs \C1, \C1, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C1, \C1, \T9  // add C9 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C1, \C1, \T10  // add T 

	adcs \C2, \C2, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C2, \C2, \T11  // add C10 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C2, \C2, \T12  // add T 

	adcs \C3, \C3, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C3, \C3, \T13  // add C11 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C3, \C3, \T14  // add T 

	adcs \CARRY_REG, \CARRY_REG, \T15  
	stp \C0, \C1, [\C_ADR, #64]  // Store C 
	stp \T2, \T3, [\C_ADR, #80]  

	/* LIMBS C12-C15 */
	ldp \T0, \T1, [\B_ADR, #96]  // Load B 
	ldp \C0, \C1, [\C_ADR, #96]  // Load C 
	ldp \T2, \T3, [\B_ADR, #112]  // Load B 
	ldp \C2, \C3, [\C_ADR, #112]  // Load C 

	mul \T8, \T0, \AI  
	umulh \T9, \T0, \AI  
	mul \T10, \T1, \AI  
	umulh \T11, \T1, \AI  
	mul \T12, \T2, \AI  
	umulh \T13, \T2, \AI  
	mul \T14, \T3, \AI  
	umulh \T15, \T3, \AI  

	adcs \C0, \C0, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C0, \C0, \T8  // add C12 

	adcs \C1, \C1, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C1, \C1, \T9  // add C13 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C1, \C1, \T10  // add T 

	adcs \C2, \C2, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C2, \C2, \T11  // add C14 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C2, \C2, \T12  // add T 

	adcs \C3, \C3, \CARRY_REG  // add carry 
	adcs \CARRY_REG, xzr, xzr  
	adcs \C3, \C3, \T13  // add C15 
	adcs \CARRY_REG, \CARRY_REG, xzr  
	adcs \C3, \C3, \T14  // add T 

	adcs \CARRY_REG, \CARRY_REG, \T15  
	stp \C0, \C1, [\C_ADR, #96]  // Store C 
	stp \T2, \T3, [\C_ADR, #112]  
	/* Store last C at [C_ADR]+1, which means offset: 128 */
	ldr \C0, [\C_ADR, #128]  
	adcs \C0, \C0, \CARRY_REG  // add carry 
	str \C0, [\C_ADR, #128] 

.endm 

/*
 C ← C + ai B 
 q ← μC mod r
 C ← (C + Nq)/r  
*/ 
.macro MUL_STEP, K, A_ADR, B_ADR, C_ADR, P_ADR, AI, CARRY_REG, C0, C1, C2, C3, T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15 
	ldr \AI, [\A_ADR ,\K] // load AI 
	/* C ← C + ai B */
	MUL_16x1 \AI, \B_ADR, \C_ADR, \CARRY_REG, \C0, \C1, \C2, \C3, \T0, \T1, \T2, \T3, \T4, \T5, \T6, \T7, \T8, \T9, \T10, \T11, \T12, \T13, \T14, \T15 
	/* q ← μC mod r , we just need to multiply C[0] with inv_min_p_mod_r */
	adrp \T0, _inv_min_p_mod_r@PAGE
	add \T0, \T0, _inv_min_p_mod_r@PAGEOFF
	ldr \T0, [\T0] // load inv_min_p_mod_r 
	ldr \T1, [\C_ADR] // load C[0] 
	mul \AI, \T0, \T1  // q ← μC mod r 
	/* C ← (C + Nq)/r */

	MUL_16x1 \AI, \P_ADR, \C_ADR, \CARRY_REG, \C0, \C1, \C2, \C3, \T0, \T1, \T2, \T3, \T4, \T5, \T6, \T7, \T8, \T9, \T10, \T11, \T12, \T13, \T14, \T15 
	/* We shift C  */
	ldr \C0, [\C_ADR, #128]  
	ldp \T0, \T1, [\C_ADR, #0]  
	ldp \T2, \T3, [\C_ADR, #16]  
	ldp \T4, \T5, [\C_ADR, #32]  
	ldp \T6, \T7, [\C_ADR, #48]  
	ldp \T8, \T9, [\C_ADR, #64]  
	ldp \T10, \T11, [\C_ADR, #80]  
	ldp \T12, \T13, [\C_ADR, #96]  
	ldp \T14, \T15, [\C_ADR, #112]  
	stp \T1, \T2, [\C_ADR, #0]  
	stp \T3, \T4, [\C_ADR, #16]  
	stp \T5, \T6, [\C_ADR, #32]  
	stp \T7, \T8, [\C_ADR, #48]  
	stp \T9, \T10, [\C_ADR, #64]  
	stp \T11, \T12, [\C_ADR, #80]  
	stp \T13, \T14, [\C_ADR, #96]  
	stp \T15, \C0, [\C_ADR, #112]  
	str xzr, [\C_ADR, #128] // set C[0] to 0 

.endm 

/*
 [x0] = [x1] * [x2] mod [p] Interleaved Montgomery multiplication  
*/
.global _fp_mul3
_fp_mul3: 
	sub sp, sp, #240
	stp lr, x0, [sp, #0]
	stp x19, x20, [sp, #16]
	stp x21, x22, [sp, #32]
	stp x23, x24, [sp, #48]
	stp x25, x26, [sp, #64]
	stp x27, x28, [sp, #80]
	str x30, [sp, #96]

	/* Load adress of P, A and B and C into respective registers */
	adrp x6, _p@PAGE
	add x6, x6, _p@PAGEOFF
	add x3, sp, #104  
	mov x1, x1  
	mov x2, x2  
	/* Init C to 0 */
	stp xzr, xzr, [x3, #0]  
	stp xzr, xzr, [x3, #16]  
	stp xzr, xzr, [x3, #32]  
	stp xzr, xzr, [x3, #48]  
	stp xzr, xzr, [x3, #64]  
	stp xzr, xzr, [x3, #80]  
	stp xzr, xzr, [x3, #96]  
	stp xzr, xzr, [x3, #112]  
	str xzr, [x3, #128] // set C[17] to 0 

	MUL_STEP #0, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #8, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #16, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #24, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #32, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #40, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #48, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #56, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #64, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #72, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #80, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #88, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #96, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #104, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #112, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 
	MUL_STEP #120, x1, x2, x3, x6, x4, x11, x7, x8, x9, x10, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28 

	/* Store Result C to [x0] and the overflow into x1 */
	ldp x12, x13, [x3, #0]  
	ldp x14, x15, [x3, #16]  
	ldp x16, x17, [x3, #32]  
	ldp x19, x20, [x3, #48]  

	stp x12, x13, [x0, #0]  
	stp x14, x15, [x0, #16]  
	stp x16, x17, [x0, #32]  
	stp x19, x20, [x0, #48]  

	ldp x12, x13, [x3, #64]  
	ldp x14, x15, [x3, #80]  
	ldp x16, x17, [x3, #96]  
	ldp x19, x20, [x3, #112]  

	stp x12, x13, [x0, #64]  
	stp x14, x15, [x0, #80]  
	stp x16, x17, [x0, #96]  
	stp x19, x20, [x0, #112]  

	ldr x1, [x3, #128] // load the overflow limb into x1, reduce_once wants it that way 
	bl _reduce_once 
	/* Restore Stack */
	ldp lr, x0, [sp, #0]
	ldp x19, x20, [sp, #16]
	ldp x21, x22, [sp, #32]
	ldp x23, x24, [sp, #48]
	ldp x25, x26, [sp, #64]
	ldp x27, x28, [sp, #80]
	ldr x30, [sp, #96]
	add sp, sp, #240
	ret 
