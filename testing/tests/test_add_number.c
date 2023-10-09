#include <stdio.h>
#include <assert.h>
#include <stdint.h>

#define LIMBS 8

typedef struct uint { uint64_t c[LIMBS]; } uint;
const struct uint p = {{
    0x1b81b90533c6c87b, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507,
    0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf,
}};
void uint_print(uint const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
       printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}
extern void add_numbers(uint64_t *a, uint64_t *b, uint64_t *c);

// a = 0 and b = 0
void add_0() {
    struct uint a = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x0000000000000000}};
    struct uint b = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x0000000000000000}};
    struct uint c = {{0}};
    struct uint result = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0x0000000000000000}};

    add_numbers(a.c, b.c, c.c);
    for(int i = 0; i < LIMBS; i++) {
        assert(c.c[i] == result.c[i]);
    }
}


void test_p_overflow() {
    struct uint a = p;
    struct uint b = {{0x1, 0x0, 0x0, 0x2, 0x0, 0x0, 0x0, 0x0}};
    struct uint result = {{0x1, 0x0, 0x0, 0x2, 0x0, 0x0,0x0, 0x0}};
    struct uint c = {{0}};
    
    add_numbers(a.c, b.c, c.c);
    
    for(int i = 0; i < LIMBS; i++) {
        assert(c.c[i] == result.c[i]);
    }
}

void test_small_add() {
    struct uint a = {{0x0, 0x2, 0x0,0x0,0x0,0x0,0x0,0x0}};
    struct uint b = {{0x0, 0x1, 0x0,0x0,0x0,0x0,0x0,0x0}};
    struct uint c = {{0}};
    struct uint result = {{0x0, 0x3, 0x0,0x0,0x0,0x0,0x0,0x0}}; 
    add_numbers(a.c, b.c, c.c);
 
    
    for(int i = 0; i < LIMBS; i++) {
        assert(c.c[i] == result.c[i]);
    }
}

int main() {
    add_0();
    test_p_overflow();
    printf("All add_number tests passed successfully!\n");
    return 0;
}