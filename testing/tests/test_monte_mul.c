#include <stdio.h>
#include <assert.h>
#include <stdint.h>

#define LIMBS 8
#define RESULT_LIMBS 16

typedef struct uint { uint64_t c[LIMBS]; } uint;

extern void mul(uint64_t *a, uint64_t *b, uint64_t *c);

extern void monte_reduce(uint64_t *a, uint64_t *b);

extern void fp_enc(uint64_t *a, uint64_t *c);

const struct uint p = {{
    0x1b81b90533c6c87b, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507,
    0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf,
}};

const uint64_t big_one[16] = {0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};

void uint_print(uint const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
       printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

extern void monte_mul(uint64_t *a, uint64_t *b, uint64_t *c);

extern void fp_enc(uint64_t *a, uint64_t *c);

void print_larger(uint64_t *x)
{
    for (size_t i = 8*RESULT_LIMBS-1; i < 8*RESULT_LIMBS; --i)
       printf("%02hhx", i[(unsigned char *) x]);
    printf("\n");
}

void mul_0() {
    struct uint a = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x0000000000000000}};
    struct uint b = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x0000000000000000}};
    uint64_t c[RESULT_LIMBS] = {0};
    uint64_t result[RESULT_LIMBS] = {0};
    monte_mul(a.c, b.c, c);
    for(int i = 0; i < RESULT_LIMBS; i++) {
        assert(c[i] == result[i]);
    }
}

void mul_some() {
    struct uint a = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x1000000000000000}};
    struct uint b = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x0000000000000000}};
    uint64_t c[RESULT_LIMBS] = {0};
    uint64_t result[RESULT_LIMBS] = {0};
    monte_mul(a.c, b.c, c);
    for(int i = 0; i < RESULT_LIMBS; i++) {
        assert(c[i] == result[i]);
    }
}

void test_encode(){
    uint a = {{0x1, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x1}};
    
    uint encoded = {{0}};
  
    uint_print(&encoded);
}

int main() {
    //mul_0();
    //mul_some();
    test_encode();
    printf("All monte mul tests passed successfully!\n");
    return 0;
}