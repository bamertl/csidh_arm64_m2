 sub     sp, sp, #96
    stp     x19, x20, [sp,#0]
    stp     x21, x22, [sp,#16]
    stp     x23, x24, [sp,#32]
    stp     x25, x26, [sp,#48]
    stp     x27, x28, [sp,#64]
    stp     x29, x30, [sp,#80]

    // x3-x8 <- AH + AL, x9 <- mask
//LOAD A
    ldp     x3, x4, [x0,#0]
    ldp     x5, x6, [x0,#16]
    ldp     x7, x8, [x0,#32]
    ldp     x10, x11, [x0,#48]
    ldp     x12, x13, [x0,#64]
    ldp     x14, x15, [x0,#80]
    // AH + AL
    adds    x3, x3, x10
    adcs    x4, x4, x11
    adcs    x5, x5, x12
    adcs    x6, x6, x13
    adcs    x7, x7, x14
    adcs    x8, x8, x15
    adc     x9, xzr, xzr
    

    // x10-x15 <- BH + BL, x16 <- mask
    ldp     x10, x11, [x1,#0]
    ldp     x12, x13, [x1,#16]
    ldp     x14, x15, [x1,#32]
    ldp     x17, x19, [x1,#48]
    ldp     x20, x21, [x1,#64]
    ldp     x22, x23, [x1,#80]    
    adds    x10, x10, x17
    adcs    x11, x11, x19
    adcs    x12, x12, x20
    adcs    x13, x13, x21
    adcs    x14, x14, x22
    adcs    x15, x15, x23
    adc     x16, xzr, xzr
    
    // x19-x24 <- masked (BH + BL)
    sub     x17, xzr, x9
    and     x19, x10, x17
    and     x20, x11, x17
    and     x21, x12, x17
    and     x22, x13, x17
    and     x23, x14, x17
    and     x24, x15, x17

    // x25-x29, x17 <- masked (AH + AL), x9 <- combined carry
    sub     x17, xzr, x16
    and     x25, x3, x17
    and     x26, x4, x17
    and     x27, x5, x17
    and     x28, x6, x17
    and     x29, x7, x17
    and     x17, x8, x17
    and     x9, x9, x16

    // x2[0-56] <- x19-x24, x9 <- masked (AH+AL) + masked (BH+BL), step 1
    adds    x19, x19, x25
    adcs    x20, x20, x26
    adcs    x21, x21, x27
    adcs    x22, x22, x28
    adcs    x23, x23, X29
    adcs    x24, x24, x17
    adc     x9, x9, xzr
    stp     x19, x20, [x2,#0]
    stp     x21, x22, [x2,#16]
    stp     x23, x24, [x2,#32]
    
    // x16-x17, x19-x28 <- (AH+AL) x (BH+BL), low part
    stp     x3, x4, [x2,#64]
    stp     x5, x6, [x2,#80]
    stp     x7, x8, [x2,#96]
    stp     x14, x15, [x2,#112]
    MUL384_KARATSUBA_COMBA_B  x2, x3, x4, x5, x6, x7, x8, x10, x11, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30  
    
    // x2[0-104] <- x23-x28, x9 <- (AH+AL) x (BH+BL), final step
    ldp     x3, x4, [x2,#0]
    ldp     x5, x6, [x2,#16]
    ldp     x7, x8, [x2,#32]
    adds    x23, x23, x3
    adcs    x24, x24, x4
    adcs    x25, x25, x5
    adcs    x26, x26, x6
    adcs    x27, x27, x7
    adcs    x28, x28, x8
    adc     x9, x9, xzr
    ldp     x3, x4, [x0,#0]
    ldp     x5, x6, [x0,#16]
    ldp     x7, x8, [x0,#32]
    ldp     x10, x11, [x1,#0]
    ldp     x12, x13, [x1,#16]
    ldp     x14, x15, [x1,#32]
    stp     x16, x17, [x2,#0]
    stp     x19, x20, [x2,#16]
    stp     x21, x22, [x2,#32]
    stp     x23, x24, [x2,#48]
    stp     x25, x26, [x2,#64]
    stp     x27, x28, [x2,#80]

    // x16-x17, x19-x28 <- AL x BL
    MUL384_KARATSUBA_COMBA  x0, x1, x2, x3, x4, x5, x6, x7, x8, x10, x11, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30
    
    // x3-x8, x10-x15, x9 <- (AH+AL) x (BH+BL) - ALxBL
    ldp     x3, x4, [x2,#0]
    ldp     x5, x6, [x2,#16]
    ldp     x7, x8, [x2,#32]
    ldp     x10, x11, [x2,#48]
    ldp     x12, x13, [x2,#64]
    ldp     x14, x15, [x2,#80]
    subs    x3, x3, x16 
    sbcs    x4, x4, x17
    sbcs    x5, x5, x19
    sbcs    x6, x6, x20
    sbcs    x7, x7, x21
    sbcs    x8, x8, x22
    sbcs    x10, x10, x23
    sbcs    x11, x11, x24
    sbcs    x12, x12, x25
    sbcs    x13, x13, x26
    sbcs    x14, x14, x27
    sbcs    x15, x15, x28
    sbc     x9, x9, xzr
    stp     x16, x17, [x2]        // Output c0-c5
    stp     x19, x20, [x2,#16]
    stp     x21, x22, [x2,#32]

    adds    x3, x3, x23 
    adcs    x4, x4, x24
    adcs    x5, x5, x25
    adcs    x6, x6, x26
    adcs    x7, x7, x27
    adcs    x8, x8, x28

    stp     x3, x4, [x2,#48]
    adc     x3, xzr, xzr
    stp     x5, x6, [x2,#64]
    stp     x7, x8, [x2,#80]
    stp     x10, x11, [x2,#96]
    stp     x12, x13, [x2,#112]
    stp     x14, x15, [x2,#128]
    neg     x3, x3
    str     x3, [x2,#144]         // Store carry

    // x16-x17, x19-x28 <- AH x BH
    ldp     x3, x4, [x0,#48]
    ldp     x5, x6, [x0,#64]
    ldp     x7, x8, [x0,#80]
    ldp     x10, x11, [x1,#48]
    ldp     x12, x13, [x1,#64]
    ldp     x14, x15, [x1,#80]
    add     x0, x0, 48
    add     x1, x1, 48
    MUL384_KARATSUBA_COMBA  x0, x1, x2, x3, x4, x5, x6, x7, x8, x10, x11, x12, x13, x14, x15, x16, x17, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30
    
    // x3-x8, x10-x15, x9 <- (AH+AL) x (BH+BL) - ALxBL - AHxBH
    ldp     x3, x4, [x2,#48]
    ldp     x5, x6, [x2,#64]
    ldp     x7, x8, [x2,#80]
    ldp     x10, x11, [x2,#96]
    ldp     x12, x13, [x2,#112]
    ldp     x14, x15, [x2,#128]
    subs    x3, x3, x16 
    sbcs    x4, x4, x17
    sbcs    x5, x5, x19
    sbcs    x6, x6, x20
    sbcs    x7, x7, x21
    sbcs    x8, x8, x22
    sbcs    x10, x10, x23
    sbcs    x11, x11, x24
    sbcs    x12, x12, x25
    sbcs    x13, x13, x26
    sbcs    x14, x14, x27
    sbcs    x15, x15, x28
    sbc     x9, x9, xzr

    ldr     x1, [x2,#144]         // Restore carry
    stp     x3, x4, [x2,#48]      // Output c6-c11
    stp     x5, x6, [x2,#64]
    adds    x1, x1, #1
    stp     x7, x8, [x2,#80]
    
    adcs    x10, x10, x16          
    adcs    x11, x11, x17
    adcs    x12, x12, x19
    adcs    x13, x13, x20
    adcs    x14, x14, x21
    adcs    x15, x15, x22
    adcs    x23, x23, x9
    adcs    x24, x24, xzr
    adcs    x25, x25, xzr
    adcs    x26, x26, xzr
    adcs    x27, x27, xzr
    adc     x28, x28, xzr

    stp     x10, x11, [x2,#96]    // Output c12-c23
    stp     x12, x13, [x2,#112]
    stp     x14, x15, [x2,#128]
    stp     x23, x24, [x2,#144]  
    stp     x25, x26, [x2,#160]   
    stp     x27, x28, [x2,#176]

    ldp     x19, x20, [sp,#0]
    ldp     x21, x22, [sp,#16]
    ldp     x23, x24, [sp,#32]
    ldp     x25, x26, [sp,#48]
    ldp     x27, x28, [sp,#64]
    ldp     x29, x30, [sp,#80]
    add     sp, sp, #96
    ret