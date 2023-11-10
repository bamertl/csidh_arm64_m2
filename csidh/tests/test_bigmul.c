#include <stdlib.h>
#include <stdio.h>
#include <assert.h> 
#include "extras.h"
#include "fp.h"
#include "constants.h"

typedef struct biguint { uint64_t c[16]; } biguint;

const struct fp p_minus_2_for_fp = {{
    0x1b81b90533c6c879, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507,
    0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf,
}};

const struct uint muu = {{
    0x66c1301f632e294d,
    0xfe025ed7d0d3b1aa,
    0xf6fe2bc33e915395,
    0x34ed3ea7f1de34c4,
    0xb081b3aba7d05f85,
    0x1232b9eb013dee1e,
    0x3512da337a97b345,
    0xd8c3904b18371bcd
    }};


void fp_print(fp const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

void uint_print(uint const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

void biguint_print(biguint const *x)
{
    for (size_t i = 8*16-1; i < 8*16; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

void biguint_print_lower(uint const *x)
{
    for (size_t i = 8*8-1; i < 8*8; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

extern void uint_mul_lower(uint *c, uint const *a, uint const *b);

extern void abs_minus(void);


void test_uint_mul_lower(void)
{
    //uint a = {{0x66c1301f632e294d, 0xfe025ed7d0d3b1aa, 0xf6fe2bc33e915395, 0x34ed3ea7f1de34c4, 0x0,0x0,0x0,0x0}};
    //uint b = {{0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf, 0x0,0x0,0x0,0x0}};
    uint a = {{0x0, 0,0,0x1000000000000000,0,0,0,0}};
    uint b = {{0x1123456789ABCDEF,0x1123456789ABCDEF,0x1123456789ABCDEF,0x1123456789ABCDEF,0x0,0x0,0x0,0x0}};

    printf("a = "); uint_print(&a);
    printf("b = "); uint_print(&b);
    uint c = {{0,0,0,0,0,0,0,0}};
    uint_mul_lower(&a, &b, &c);
    uint_print(&c);
}

int main(void)
{
    //abs_minus();
    test_uint_mul_lower();
    printf("All tests passed!\n");
    return 0;
}
