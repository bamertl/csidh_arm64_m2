#include <stdio.h>
#include <assert.h>
#include <stdint.h>

#define LIMBS 8
#define RESULT_LIMBS 16

typedef struct uint { uint64_t c[LIMBS]; } uint;

extern void mul(uint64_t *a, uint64_t *b, uint64_t *c);


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
    mul(a.c, b.c, c);
    for(int i = 0; i < RESULT_LIMBS; i++) {
        assert(c[i] == result[i]);
    }
}

void mul_some() {
    struct uint a = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x1000000000000000}};
    struct uint b = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x0000000000000000}};
    uint64_t c[RESULT_LIMBS] = {0};
    uint64_t result[RESULT_LIMBS] = {0};
    mul(a.c, b.c, c);
    for(int i = 0; i < RESULT_LIMBS; i++) {
        assert(c[i] == result[i]);
    }
}

void actual_mul() {
    struct uint a = {{0x1, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x0}};
    struct uint b = {{0x2, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x0}};

    uint64_t c[RESULT_LIMBS] = {0};
    uint64_t result[RESULT_LIMBS] = {0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,0x0,0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
    mul(a.c, b.c, c);
    for(int i = 0; i < RESULT_LIMBS; i++) {
        assert(c[i] == result[i]);
    }
}

void more_mul() {
    struct uint a = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x9999999999999999}};
    struct uint b = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x2000000000000000}};

    uint_print(&a);
    uint_print(&b);
    uint64_t c[RESULT_LIMBS] = {0};
    uint64_t result[RESULT_LIMBS] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,0x0,0x0, 0x0, 0x0, 0x0, 0x2000000000000000, 0x1333333333333333};
    mul(a.c, b.c, c);
    print_larger(c);
    print_larger(result);
    
    for(int i = 0; i < RESULT_LIMBS; i++) {
        assert(c[i] == result[i]);
    }
}

int main() {
    mul_0();
    mul_some();
    actual_mul();
    more_mul();
    printf("All add_number tests passed successfully!\n");
    return 0;
}