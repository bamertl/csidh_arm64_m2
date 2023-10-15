#include <stdio.h>
#include <assert.h>
#include <stdint.h>

#define LIMBS 8
#define RESULT_LIMBS 16

typedef struct uint { uint64_t c[LIMBS]; } uint;

extern void monte_mul(uint64_t *a, uint64_t *b, uint64_t *c);


void uint_print(uint const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
       printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

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


int main() {
    mul_0();
    mul_some();
    printf("All monte mul tests passed successfully!\n");
    return 0;
}