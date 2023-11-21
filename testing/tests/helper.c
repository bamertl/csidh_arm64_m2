#include "helper.h"
#include <stdio.h>
#include <assert.h> 

void uintbig_print(uintbig const *x){
    for (size_t i = 8*UINTBIG_LIMBS-1; i < 8*UINTBIG_LIMBS; --i){
        printf("%02hhx", i[(unsigned char *) x->c]);
    }
    printf("\n");
}

void uintbig_assert_equal(uintbig const *expected, uintbig const *actual){
    for(int i = 0; i < UINTBIG_LIMBS; i++) {
        assert(expected->c[i] == actual->c[i]);
    }
}

fp fp_p = {{
    0x1b81b90533c6c87b, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507,
	0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf
}};
