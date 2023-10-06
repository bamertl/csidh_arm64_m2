#include <stdio.h>
#include <stdint.h>

extern void add_numbers(uint64_t *a, uint64_t *b, uint64_t *c);
extern void minus_number(uint64_t *a, uint64_t *b);
#define LIMBS 8

typedef struct uint { uint64_t c[LIMBS]; } uint;

const struct uint p = {{
    0x1b81b90533c6c87b, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507,
    0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf,
}};

const struct uint p_cofactor = {{4}};

void uint_print(uint const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
       printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

int main() {
    uint a = p; 
    uint b = {{0x0, 0x0, 0x0, 0x0,0x0,0x0,0x0, 0xF000000000000000}};
    uint c = {{0}};
    add_numbers(a.c, b.c, c.c);

    uint_print(&c);
    uint_print(&p);
    printf("Now subtract\n");
    
    uint z = {{0x0, 0x0, 0x0, 0x0, 0x0, 0x0,0x0, 0x0}};
    minus_number(z.c, c.c);
    uint_print(&c);

    return 0;

}
