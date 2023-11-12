For now working in testing folder, addition and subtraction implemented
[implementations](testing)

[ASM Files](testing/asm)

For CSIDH:
[CSIDH](csidh)


#Subtractive Karatsuba
A=AH,AL B=BH,BL
n = amount of bits in A or B, 2n = result bits
L = AL * BL
H = AH * BH 

AD = |AL-AH| -> two's complement if negative for abs value, save sign
BD = |BL-BH| -> two's complement if negative for abs value, save sign

M = AD*BD
M = signAD*signBD * M (if signs are not equal, in the final step it needs to be +M and not -M this is why here maybe 2's complement)

C = H*2^n + (H+L-M)*2^(n/2) + L