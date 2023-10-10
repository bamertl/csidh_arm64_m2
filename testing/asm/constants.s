.global p511 mu n

p511:
.quad   0x1b81b90533c6c87b
.quad   0xc2721bf457aca835
.quad   0x516730cc1f0b4f25
.quad   0xa7aac6c567f35507
.quad   0x5afbfcc69322c9cd
.quad   0xb42d083aedc88c42
.quad   0xfc8ab0d15e3e4c4a
.quad   0x65b48e8f740f89bf

// mu = -p^-1 mod 2^512
mu:
.quad   0x66c1301f632e294d
.quad   0xfe025ed7d0d3b1aa
.quad   0xf6fe2bc33e915395
.quad   0xd8c3904b18371bcd
.quad   0x3512da337a97b345
.quad   0x1232b9eb013dee1e
.quad   0xb081b3aba7d05f85
.quad   0x34ed3ea7f1de34c4

n:
.word 512
// The modulus N is such that r^(n−1) ≤ p < r^n and r and N are coprime. R = r^n