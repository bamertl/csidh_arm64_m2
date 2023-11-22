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

fp r_squared_mod_p = {{
    0x36905b572ffc1724, 0x67086f4525f1f27d, 0x4faf3fbfd22370ca, 0x192ea214bcc584b1,
    0x5dae03ee2f5de3d0, 0x1e9248731776b371, 0xad5f166e20e4f52d, 0x4ed759aea6f3917e,
}};
