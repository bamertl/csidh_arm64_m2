

.extern p511
// Macro to load a 8 Word Number into 8 registers from a num_pointer
.macro LOAD_8_WORD_NUMBER, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, num_pointer
    LDP \reg1, \reg2, [\num_pointer,#0] 
    LDP \reg3, \reg4, [\num_pointer,#16]
    LDP \reg5, \reg6, [\num_pointer,#32]
    LDP \reg7, \reg8, [\num_pointer, #48]
.endm
// Macro to store an 8 word number from reg1-8 to destination_pointer
.macro STORE_8_WORD_NUMBER, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, destination_pointer
    STP \reg1, \reg2, [\destination_pointer,#0] 
    STP \reg3, \reg4, [\destination_pointer,#16]
    STP \reg5, \reg6, [\destination_pointer,#32]
    STP \reg7, \reg8, [\destination_pointer, #48]
.endm

// Macro to load the 511 Prime into reg1-8
.macro LOAD_511_PRIME, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8
    LDR \reg1, p511
    LDR \reg2, p511 + 8
    LDR \reg3, p511 + 16
    LDR \reg4, p511 + 24
    LDR \reg5, p511 + 32
    LDR \reg6, p511 + 40
    LDR \reg7, p511 + 48
    LDR \reg8, p511 + 56
.endm
